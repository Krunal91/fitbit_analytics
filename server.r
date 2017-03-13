library(shiny)
library(ggplot2)
library(fitbitScraper)

function(input, output) {
  cookie =eventReactive(input$logon,{login(input$email,input$pass)})
  
  options  = reactiveValues(value = 'steps')
  observeEvent(input$steps,{options$value='steps'})
  observeEvent(input$distance,{options$value='distance'})
  

  data = reactive({
    get_daily_data(cookie(),what = options$value,start_date = as.character(input$startdate),
                        end_date = as.character(input$enddate))})
  
  
  
  output$scatter = renderPlot({ggplot(data(),aes(data()$time,data()[,options$value])) +geom_line()})
  #output$scatter =renderPlot({hist(rnorm(100))})
  output$result = renderPrint({options()})
  
}


# options = reactive({switch (input$options,
#                   Steps = 'steps',
#                   Distance ='distance',
#                   Floors='floors',
#                   Minutes= 'minutesVery'
# )})