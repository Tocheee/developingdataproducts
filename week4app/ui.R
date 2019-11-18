#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/ 
#

library(shiny)
library(leaflet)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Permanent Residency Admissions 2015 - 2019"),

  h3(strong("Instructions: Select a year from the drop-down below to see the change in distribution of countries of origin.")),
  
  
  h4(("Contains information licensed under the Open Government Licence – Canada.")),
  h4(("LICENSE: https://open.canada.ca/en/open-government-licence-canada")),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      selectInput("year",
                   "Year",
                   choices = c("2015","2016","2017","2018","2019")
      )),
    
    # Show a plot of the generated distribution
    mainPanel(
      leafletOutput("pr_map"),
      p()
    )
  )
))
