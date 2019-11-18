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
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       radioButtons("year",
                   "Year",
                   choices = c("2015","2016","2017","2018","2019")
       )),
                   
    # Show a plot of the generated distribution
    mainPanel(
       leafletOutput("pr_map"),
       p(),
       actionButton("recalc", "See new data")
    )
  )
))
