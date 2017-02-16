# Author: Sharan Naribole
# Filename: ui.R
# H-1B Visa Petitions Dashboard web application to enable exploratory data analysis
# on H-1B Visa applications disclosure data in the period 2011-2016

library(shiny)
library(shinythemes)
library(shinyjs)

# List of choices for States input
states = toupper(c("usa","alaska","alabama","arkansas","arizona","california","colorado",
  "connecticut","district of columbia","delaware","florida","georgia",
  "hawaii","iowa","idaho","illinois","indiana","kansas","kentucky",
  "louisiana","massachusetts","maryland","maine","michigan","minnesota",
  "missouri","mississippi","montana","north carolina","north dakota",
  "nebraska","new hampshire","new jersey","new mexico","nevada",
  "new york","ohio","oklahoma","oregon","pennsylvania","puerto rico",
  "rhode island","south carolina","south dakota","tennessee","texas",
  "utah","virginia","vermont","washington","wisconsin",
  "west virginia","wyoming"))
state_list <- as.list(states)
names(state_list) <- states

# Define UI for application that draws a histogram
shinyUI(
  
  fluidPage(
      
  useShinyjs(),  
  #shinythemes::themeSelector(),  
  theme = shinythemes::shinytheme("slate"),
  
  # Application title
  titlePanel("H-1B Visa Petitions Data Exploration"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      
      # CSS style for loading message whenever
      # Shiny is busy
      tags$head(tags$style(type="text/css", "
             #loadmessage {
                           position: fixed;
                           top: 0px;
                           left: 0px;
                           width: 100%;
                           padding: 5px 0px 5px 0px;
                           text-align: center;
                           font-weight: bold;
                           font-size: 100%;
                           color: #000000;
                           background-color: #CCFF66;
                           z-index: 105;
                           }
                           ")),
      
      # Container unit for all inputs
      # Helps in resetting all inputs to default by Reset button
      div(
      
         id ="inputs",  
       
         # Compute button triggers server to update the outputs
         p(actionButton("resetAll", "Reset All Inputs"),
           actionButton("compute","Compute!", icon = icon("bar-chart-o"))),
         
         # Year range determines the period for data analysis
         sliderInput("year",
                     h3("Year"),
                     min = 2011,
                     max = 2016,
                     value = c(2011,2016)),
         
         br(),

         h3("Job Type"),
         h6("Type up to three job type inputs. If no match found for all inputs, the app considers all Job Titles in the records for Job Type."),
         
         div(
           id = "job_type",
           
           # Default inputs selected from my personal interest
           textInput("job_type_1", "Job Type 1","Data Scientist"),
           textInput("job_type_2", "Job Type 2","Data Engineer"),
           textInput("job_type_3", "Job Type 3", "Machine Learning")
         ),
         
         selectInput("metric",
                     h3("Metric"),
                     choices = list("Total Visa Applications" = "TotalApps",
                                    "Wage" = "Wage",
                                    "Certified Visa Applications" = "CertiApps"
                                   )
         ),
         
         selectInput("location",
                     h3("Location"),
                     choices = state_list),
         
         h3("Employer Name"),
         h6("Defaults to All if no match found."),
         div(
           id = "employer",
           textInput("employer_1", "Employer 1",""),
           textInput("employer_2", "Employer 2",""),
           textInput("employer_3", "Employer 3", "")
         ),
         
         sliderInput("Ntop",
                     h3("No. of categories in plots"),
                     min = 3,
                     max = 15,
                     value = 3)
         
         #p(actionButton("updateEmployer", "Update Employers"), actionButton("resetEmployer", "Reset Employers"))
       ),
      conditionalPanel(condition="$('html').hasClass('shiny-busy')",
                       tags$div("Loading...",id="loadmessage"))
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        tabPanel("Debug", 
                 verbatimTextOutput("debugJobList"),
                 br(),
                 verbatimTextOutput("debugJobInput"),
                 br(),
                 verbatimTextOutput("debugEmployerList"),
                 br(),
                 verbatimTextOutput("debugEmployerInput"),
                 
                 br(),
                 
                 dataTableOutput("dataInput"),
                 
                 br(),
                 
                 verbatimTextOutput("metricInput")
                 ),
        tabPanel("Job Type",
                 plotOutput("job_type"),
                 br(),
                 br(),
                 dataTableOutput("job_type_table")
                 ),
        tabPanel("Location",
                 plotOutput("location"),
                 br(),
                 br(),
                 dataTableOutput("location_table")),
         tabPanel("Employers",
                  plotOutput("employer"),
                  br(),
                  br(),
                  dataTableOutput("employertable")),
        tabPanel("Map",
                 plotOutput("map"),
                 br(),
                 dataTableOutput("map_table"))
      )
       
    )
  )
))
