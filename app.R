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

# Read in database
GTD <- read_csv('data/globalterrorismdb.csv', col_types = readr::cols())
GTD_focus <-
  GTD %>%
  select(iyear, country, country_txt, gname, attacktype1, 
         attacktype1_txt, nkill, nwound, motive) %>%
  mutate(nhurt = nkill + nwound)

ui <- 
  dashboardPage(
    dashboardHeader(title = 'Global Terrorism Plots'),
    dashboardSidebar(
      sidebarMenu(
        menuItem('Geographic Distribution', tabName = 'tab1'),
        menuItem('Top Perpetrators', tabName = 'tab2'),
        menuItem('Attack Types', tabName = 'tab3')
      )
    ),
    dashboardBody(
      tabItems(
        tabItem(
          tabName = 'tab1', 
          fluidRow(
            column(9, )
          )
        ),
      )
    )
  )











