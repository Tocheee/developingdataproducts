#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

#Read in libraries
#For data manipulation and cleaning
library(tidyverse)
#For map creation
library(leaflet)
# For longitude and latitude information
# install.packages("rgeos")
library(rgeos)
# install.packages("rworldmap")
library(rworldmap)
library(shiny)

pr_data <- read_csv("pr_admissions.csv", 
                    col_types =  c(.default = "c",
                                  `Canada - Admissions of Permanent Residents by Country of Citizenship, January 2015 - August 2019` = "c"))
#Data cleaning
pr_data <- pr_data %>% 
  select_if(str_detect(. ,pattern="201.*Total|2019"))
 
#Rename the columns and remove na rows
pr_data <- pr_data %>% 
  rename(`Country of Origin` = `Canada - Admissions of Permanent Residents by Country of Citizenship, January 2015 - August 2019`,
         "2015" = "X18",
         "2016" = "X35",
         "2017" = "X52",
         "2018" = "X69",
         "2019" = "X81") %>%
  select(-"X70") %>% 
  na.omit()

#Filter out the row with the column total

pr_data <- filter(pr_data,!str_detect(`Country of Origin`,"Total")) 
 
pr_data$`Country of Origin` <- str_replace(pr_data$`Country of Origin`,",.*","")
 
#Make the columns numeric
pr_data <- pr_data %>% 
  mutate(`2015` = as.numeric(str_replace(pr_data$`2015`,",","")),
         `2016` = as.numeric(str_replace(pr_data$`2016`,",","")),
         `2017` = as.numeric(str_replace(pr_data$`2017`,",","")),
         `2018` = as.numeric(str_replace(pr_data$`2018`,",","")),
         `2019` = as.numeric(str_replace(pr_data$`2019`,",","")))

#Rename a few specific rows
pr_data$`Country of Origin`[35] = "Democratic Republic of the Congo"
pr_data$`Country of Origin`[36] = "Republic of the Congo"
pr_data$`Country of Origin`[86] = "North Korea"
pr_data$`Country of Origin`[87] = "South Korea"

#This section of the script uses the code from this stack overflow question - https://gis.stackexchange.com/questions/71921/list-of-central-coordinates-centroid-for-all-countries
#########
#Get centroids for the countries
# get world map
wmap <- getMap(resolution="high")
 
# get centroids
centroids <- gCentroid(wmap, byid=TRUE)
# get a data.frame with centroids
df <- as.data.frame(centroids)
#########
#Merge the longitude and latitude data with the pr information

#Convert the df rownames to columns
df <- rownames_to_column(df,"Country")
pr_data <- merge(df,pr_data,by.x="Country",by.y="Country of Origin") %>% 
  rename(Longitude = x,
         Latitude = y)


# Define server logic required to draw a histogram
shinyServer(function(input, output, session) { 
  
output$pr_map <- renderLeaflet({
  pr_data <- pr_data %>%
    select(`Country`,
           input$year,
           "Longitude",
           "Latitude")
  pr_data <- pr_data %>% 
    rename(Total = input$year)
  
  #Create a new column that is a concatenation between the country name and the total
  pr_data$`Country and Total` <- paste(pr_data$Country,pr_data$Total,sep=", ")
   
  
  pr_data %>% 
    leaflet() %>% 
    addTiles() %>% 
    addCircleMarkers(radius = as.numeric(pr_data$Total)/1000,
                     label = pr_data$`Country and Total`, 
                     fill= pr_data$Total, 
                     lng = pr_data$Longitude, 
                     lat=pr_data$Latitude)
    
  })
  
})

