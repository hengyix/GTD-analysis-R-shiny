library(viridis) 
library(tidyverse)
library(ggrepel)
library(shinythemes)
library(shiny)
library(dplyr)
library(readr)
library(ggplot2)
library(maps)
library(terra)
library(shinydashboard)
library(plotly)
library(rlang)
library(RColorBrewer)
library(stringr)

# Read in and clean the database 
GTD <- read_csv('data/globalterrorismdb.csv', col_types = readr::cols())
GTD_clean <-
  GTD %>%
  select(iyear, country, country_txt, gname, attacktype1, 
         attacktype1_txt, nkill, nwound, motive) %>%
  mutate(nhurt = nkill + nwound)
# Identify countries in South Asia
SA <- c('Afghanistan','Bangladesh', 'Bhutan', 'India', 'Pakistan', 
        'Maldives', 'Nepal', 'Sri Lanka') 

# Divide countries into three regions
GTD_clean <-
  GTD_clean %>%
  mutate(region = case_when(
    country_txt == 'Iraq' ~ 'Iraq',
    country_txt %in% SA ~ 'South Asia',
    .default = 'Other Regions'))

# UI design
ui <- dashboardPage(
  dashboardHeader(title = 'Global Terrorism (1970-2020)',
                  titleWidth = 300),
  # Three sessions
  dashboardSidebar(width = 300,
                   sidebarMenu(
                     menuItem('Geographic Distribution', tabName = 'tab1'),
                     menuItem('Top Perpetrators', tabName = 'tab2'),
                     menuItem('Attack Types', tabName = 'tab3')
                     )
                   ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "tab1",
              fluidRow(
                column(1), # Leave some blank space at the margin 
                column(8, box(status = "primary", 
                              plotlyOutput("geo_attack"), 
                              width = NULL)
                       ),
                column(2, box(status = "warning", 
                              radioButtons(inputId = 'choice', 'Count by', 
                                           c('Events' = 'attack_count',
                                             'Casualties' = 'casualties')),
                              width = NULL)
                       ),
                column(1) # Blank space
                ), 
              fluidRow(
                column(1), 
                column(8, box(status = "primary", 
                              tableOutput('geo_table'), 
                              width = NULL)
                       ),
                column(2, box(status = "warning", 
                              selectInput("yearSelect", "Choose a Year:",
                                          choices = 1970:2020, 
                                          selected = 1970),
                           selectInput('rank_by', 'Sort by:', 
                                       c('Events' = 'attack_count',
                                         'Casualties' = 'casualties')),
                           width = NULL)
                       ),
                column(1)
                )
              ),
      
      tabItem(tabName = "tab2",
              fluidPage(
                fluidRow(column(1), # Stay according to the previous page
                  column(7, box(status = 'primary', 
                                plotlyOutput("gnames_first"), 
                                width=NULL)
                         ),
                  column(3,  box(status = 'warning', 
                                 radioButtons(inputId = 'region_tab2', 'Region:', 
                                              c('Iraq', 'South Asia', 'Other Regions')),
                                 'Note: South Asia includes Bangladesh, Bhutan, 
                                 India, Maldives, Nepal, Pakistan, Sri Lanka, 
                                 and Afghanistan here.', br(), 
                                 width = NULL),
                         box(status = 'success', 
                             width = NULL, 
                             title = 'Globally',
                             "Entities behind the vast majority of terrorist 
                             incidents remain unknown, and there does not exist 
                             an identified entity active across the world.", br(), 
                             "But when zooming into Iraq and South Asia, 
                             Islamic State of Iraq and the Levant (ISIL) and 
                             Taliban stand out respectively.")
                         ), 
                  column(1)
                ),
                fluidRow(
                  column(1),
                  column(width = 5, 
                         box(
                           title = "In Iraq", solidHeader = TRUE, status = 'info',
                           "ISIL is the most active identified perpetrator.",
                           br(), plotOutput('ISIL_count'), width = NULL)
                  ),
                  column(width = 5,
                         box(
                           title = "In South Asia", solidHeader = TRUE, status = 'danger',
                           "Taliban is the most active identified perpetrator.",
                           br(), plotOutput('Taliban_count'), width = NULL)
                  ),
                  column(1)
                )
              )
              
      ),
      
      tabItem(tabName = 'tab3',
              fluidPage(
                fluidRow(
                  column(1), 
                  column(7,  box(status = 'primary', 
                                 plotlyOutput('type_plot'), 
                                 width = NULL)
                         ),
                  column(3,  box(status = 'warning', 
                                 radioButtons(inputId = 'region_choice', 
                                              'Region:', 
                                              c('Iraq', 'South Asia', 'Other Regions')),
                                 'Note: South Asia includes Bangladesh, Bhutan, 
                                 India, Maldives, Nepal, Pakistan, Sri Lanka, 
                                 and Afghanistan here.', 
                                 br(), br(),
                                 '9 attack types are:', 
                                 'Armed Assault, Assassination, Bombing/Explosion,
                                 Facility/Infrastructure Attack, Hijacking, 
                                 Hostage Taking (Barricade Incident),
                                 Hostage Taking (Kidnapping), Unarmed Assault, Unknown.',
                                 width = NULL)
                         ),
                  column(1)
                )
              ),
              fluidRow(column(1), 
                       column(7, box(status = 'primary', 
                                     plotOutput('type_overtime'), 
                                     width = NULL)
                              ),
                       column(3, box(status = 'warning',
                                     selectInput(inputId = 'type_choice', 'Type:',
                                                 c('Armed Assault',
                                                   'Assassination',
                                                   'Bombing/Explosion',
                                                   'Facility/Infrastructure Attack',
                                                   'Hijacking',
                                                   'Hostage Taking (Barricade Incident)',
                                                   'Hostage Taking (Kidnapping)',
                                                   'Unarmed Assault',
                                                   'Unknown'),
                                                 selected = "Bombing/Explosion"),
                                     width = NULL
                                     )
                              ),
                       column(1)
                       )
              )
      )
    )
  )

# Server design
server <- function(input, output){
  ## Tab1
  # Heatmap
  output$geo_attack <- renderPlotly({
    # Prepare data for the map: matching different country names
    GTD_clean$country_txt[GTD_clean$country_txt == 'United States'] <- 'USA'
    GTD_map <-
      GTD_clean %>%
      group_by(country_txt) %>%
      summarise(attack_count = n(), 
                casualties = sum(nhurt, na.rm = TRUE),
                .groups = 'drop')
    
    # Matching data with world dataset
    world <- map_data('world')
    worldSubset <- left_join(world, GTD_map, by = c('region' = 'country_txt'))
    # Remove country out of the research 
    worldSubset <- 
      worldSubset %>% 
      filter(region != 'Antarctica')
    
    # Draw the ggplot
    geo_plot <- ggplot(mapping = aes(x = long, y = lat, group = group, text = region)) +
      coord_fixed(1.3) +
      geom_polygon(data = worldSubset, aes_string(fill = input$choice)) + 
      scale_fill_distiller(palette ="Reds", direction = 1, na.value = 'grey') +
      labs(title = "Geographic Distribution of Terrorist Events") + 
      theme(
        axis.text = element_blank(),
        axis.line = element_blank(),
        axis.ticks = element_blank(),
        panel.border = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.title = element_blank(),
        panel.background = element_rect(fill = "lightblue")
        )
    
    # Adding interactivity
    ggplotly(geo_plot, tooltip = c(input$choice, 'region')) 
    })
  
  # Table
  output$geo_table <- renderTable({
    GTD_map_year <-
      GTD_clean %>%
      group_by(country_txt, region, iyear) %>%
      summarise(attack_count = n(), 
                casualties = sum(nhurt, na.rm = TRUE), 
                .groups = 'drop') %>%
      mutate(iyear = as.integer(iyear), 
             attack_count = as.integer(attack_count), 
             casualties = as.integer(casualties))
    
    GTD_map_year %>%
      filter(iyear == input$yearSelect) %>%
      arrange(desc(!!sym(input$rank_by)))
  })
  
  ## Tab2
  # Active groups
  output$gnames_first <- renderPlotly({
    GTD_gnames <-
      GTD_clean %>% 
      select(region, gname) %>%
      group_by(region, gname) %>%
      summarise(count = n()) %>%
      mutate(Percentage = count/sum(count)) %>%
      arrange(-Percentage) %>%
      slice_head(n = 10) # Showing top 10 groups
    
    # Define a palette for 13 variables
    fill_colors <- c(brewer.pal(8, "Dark2"), brewer.pal(12, "Paired"))
    
    gnames_first_base <- 
      ggplot(data = subset(GTD_gnames, region == input$region_tab2)) + 
      geom_bar(aes(y = Percentage, x = reorder(gname, -Percentage), fill = gname), 
               stat = 'identity') + 
      scale_fill_manual(values = fill_colors) + 
      scale_x_discrete(label = function(x) str_trunc(x, 8)) + # Truncate xlabels
      theme(axis.text.x = element_text(angle =45, vjust = 1, hjust=1)) + # Rotating xlabels
      guides(fill = 'none') + 
      theme(panel.background = element_rect(fill = '#faf6f0')) + 
      xlab('Group Names') + 
      ylab('Proportion') + 
      labs(title = "Groups Responsible for Most Attacks") 
    
    ggplotly(gnames_first_base, tooltip = 'gname')
  })
  
  # Attack count by ISIL and Taliban over time
  # ISIL
  output$ISIL_count <- renderPlot({
    GTD_ISIL_time <- 
      GTD_clean %>%
      filter(gname == 'Islamic State of Iraq and the Levant (ISIL)') %>%
      group_by(iyear) %>%
      summarise(count = n())
    
    ggplot(data = GTD_ISIL_time) + 
      geom_line(aes(x = iyear, y = count)) + 
      labs(title = 'Attack Count Over Time by ISIL: from 2013') + 
      scale_y_continuous(limits = c(0, 2000), breaks = c(0, 500, 1000, 1500, 2000)) + 
      scale_x_continuous(breaks = c(2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020)) +
      xlab('Year') + 
      ylab('Count') +
      theme(
        panel.background = element_rect(fill = '#faf6f0'),
        plot.title = element_text(hjust = 0.5, face = "bold", size = 14)
      ) 
  })
  # Taliban
  output$Taliban_count <- renderPlot({
    GTD_Taliban_time <- 
      GTD_clean %>%
      filter(gname == 'Taliban') %>%
      group_by(iyear) %>%
      summarise(count = n())
    
    ggplot(data = GTD_Taliban_time) + 
      geom_line(aes(x = iyear, y = count)) + 
      labs(title = 'Attack Count Over Time by Taliban: from 1995') + 
      xlab('Year') + 
      ylab('Count') +
      theme(
        panel.background = element_rect(fill = '#faf6f0'),
        plot.title = element_text(hjust = 0.5, face = "bold", size = 14)
      ) 
  })
  
  # Tab3
  # Attack type proportion
  output$type_plot <- renderPlotly({
    GTD_type_total <-
      GTD_clean %>%
      select(region, attacktype1_txt, gname) %>%
      group_by(region) %>%
      summarise(count_total = n()) # Subtotal of events by region
    
    GTD_type <-
      GTD_clean %>%
      select(region, attacktype1_txt, gname) %>%
      group_by(region, attacktype1_txt, gname) %>%
      summarise(count = n()) # Count of events by attack type in each region
    
    GTD_type <-
      left_join(GTD_type, GTD_type_total, by = c('region')) 
    
    GTD_type <-
      GTD_type %>%
      mutate(Percentage = count/count_total) %>%
      group_by(region, attacktype1_txt) %>%
      summarise(Proportion = sum(Percentage))
    
    type_base <- ggplot(data = subset(GTD_type, region == input$region_choice)) +
      geom_col(aes(x = reorder(attacktype1_txt, Proportion), 
                   y = Proportion, 
                   fill = attacktype1_txt)) + 
      scale_x_discrete(label = function(x) str_trunc(x, 13)) + 
      coord_flip() + 
      scale_fill_brewer(palette = "Paired") + 
      theme(
        axis.text.x = element_text(angle = 0, vjust = 1, hjust=0.5),
        panel.background = element_rect(fill = '#faf6f0'),
        legend.position = "none"
      ) + 
      labs(title = "Attack Types Proportion") + 
      xlab('Attack Types') + 
      ylab('Proportion')
    
    type_plot <- ggplotly(type_base, tooltip = 'attacktype1_txt')
  })
  
  # Each attack type over time
  output$type_overtime <- renderPlot({
    GTD_type <- 
      GTD_clean %>%
      group_by(attacktype1_txt, iyear,region) %>%
      summarise(count = n())
    # Adjust the order
    GTD_type$region <- factor(GTD_type$region, 
                              levels = c("Iraq", "South Asia", "Other Regions"))
    
    ggplot(data = subset(GTD_type, attacktype1_txt == input$type_choice)) + 
      geom_line(aes(x = iyear, y = count)) + 
      facet_grid(~region) + 
      labs(title = 'Attack Type Frequency Over Time by Region') + 
      theme(
        panel.background = element_rect(fill = '#faf6f0'),
        plot.title = element_text(size = 16),
        axis.title.x = element_text(size = 16),
        axis.title.y = element_text(size = 16)
      ) + 
      xlab('Year') + 
      ylab('Count')
  })
}

# Run the application
shinyApp(ui = ui, server = server)









