library(shiny)
library(ggplot2)

dataset <- diamonds

fluidPage(
  
  titlePanel(h1("FitBit Analytics",align="center")),
  
  sidebarPanel(
    
    textInput('email', 'Login Email:'),
    passwordInput('pass', 'Password'),
    actionButton('logon','LogIn'),
    dateInput('startdate','Start Date'),
    dateInput('enddate','End Date'),
    
    actionButton('steps','Steps'),
    actionButton('distance','Distance'),
    verbatimTextOutput('value')
  ),
  
  mainPanel(
    plotOutput('scatter'),
    verbatimTextOutput('result')
    

  )
)

#radioButtons('options','Choose an Option',c('Steps','Distance',
 #                                           'Floors','Minutes')),

# selectInput('facet_row', 'Facet Row', c(None='.', names(dataset))),
# selectInput('facet_col', 'Facet Column', c(None='.', names(dataset)))