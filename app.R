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

# Read in and clean the database 
GTD <- read_csv('data/globalterrorismdb.csv', col_types = readr::cols())
GTD_clean <-
  GTD %>%
  select(iyear, country, country_txt, gname, attacktype1, 
         attacktype1_txt, nkill, nwound, motive) %>%
  mutate(nhurt = nkill + nwound)

# Define South Asia nations

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












