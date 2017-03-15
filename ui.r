library(shiny)
library(ggplot2)
library(plotly)
library(shinythemes)


navbarPage("FitBit Analytics",
           theme = shinytheme("darkly"),
           
           tabPanel("Home",
                    
                    fluidRow(
                      column(4,
                             br(),
                             textInput('email', 'Login Email:'),
                             passwordInput('pass', 'Password'),
                             actionButton("logon","Login"),
                             #dateInput('startdate','Start Date'),
                             #dateInput('enddate','End Date'),
                             tags$br(),tags$br(),
                             dateRangeInput('daterange',"Select Date Range",start = Sys.Date()-15),
                             verbatimTextOutput("test")
                             
                             
                             
                      ),
                      
                      column(8,
                             h5("Choose an Option"),
                             actionButton('steps','Steps'),
                             actionButton('distance','Distance'),
                             actionButton('floors','Floors'),
                             actionButton('minutesVery','Minutes'),
                             # actionButton('caloriesBurnedVsIntake','Calories'),
                             # actionButton('getRestingHeartRateData','Resting HR'),
                             tags$br(),
                             tags$br(),
                             
                             plotlyOutput('scatter')
                             
                      ),
                      
                      column(6,
                             br(),
                             br(),
                             uiOutput("calory_title"),
                             plotlyOutput('scatter_calory')
                             
                      ),
                      
                      column(6,
                             br(),
                             br(),
                             uiOutput("pie_title"),
                             plotlyOutput('pie_act')
                             
                      ),
                      
                      
                      column(6,
                             br(),
                             br(),
                             uiOutput("heart_title"),
                             plotlyOutput('scatter_heart')
                             
                      ),
                      column(6,
                             br(),
                             br(),
                             uiOutput("sleep_title"),
                             plotlyOutput('heartVsleep')
                             
                      ))),
           
           tabPanel("Health Status",
                    column(6,
                           br(),
                           br(),
                           h4("Are you healthy or not?"),
                           br(),
                           br(),
                           p("Here, we will count your BMI and then on the plot you will 
           see, where you stand in that grpah."),
                           p("Please enter your heigt in inches and weight in lbs,than click on calculate button."),
                           numericInput('height','Height in Inches',value = 56),
                           numericInput('weight','Weight in lbs',value = 87),
                           actionButton("calculate","Calculate"),
                           br(),
                           br(),
                           verbatimTextOutput("bmi")
                    ),
                    
                    column(6,
                           br(),
                           br(),
                           uiOutput("title_6"),
                           plotlyOutput("bmi_plot")
                           
                    )
           ),
           
           
           
           tabPanel("About Me",
                    column(4,
                           includeHTML("linkedin.html")
                           )
                           )
           
           
)

