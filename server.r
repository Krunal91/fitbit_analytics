library(shiny)
library(openssl)
library(rsconnect)
library(ggplot2)
library(fitbitScraper)
library(ggthemes)
library(plotly)
library(dplyr)
library(devtools)
function(input, output,session) {
  cookie =eventReactive(input$logon,{login(input$email,input$pass)})
  
  options  = reactiveValues(value = 'steps')
  observeEvent(input$steps,{options$value='steps'})
  observeEvent(input$distance,{options$value='distance'})
  observeEvent(input$floors,{options$value='floors'})
  observeEvent(input$minutesVery,{options$value='minutesVery'})
  
  
  
  plt_title = reactiveValues(value = "Number of Steps Per Day")
  observeEvent(input$steps,{plt_title$value="Number of Steps Per Day"})
  observeEvent(input$distance,{plt_title$value="Number of Miles Per Day"})
  observeEvent(input$floors,{plt_title$value="Number of Floors Per Day"})
  observeEvent(input$minutesVery,{plt_title$value="Number of Active Minutes Per Day"})
  
  
  bmi_range = c(10,16,17,18.5,25,30,35,40,50)
  body_type = c("Severe Thinness","Moderate Thinness","Mild Thinness",
                "Normal","Overweight","Obese Class I","Obese Class II",
                "Obese Class III","Obese Class III")
  
  latest_weight = reactive({get_weight_data(cookie(),start_date = as.character(Sys.Date()),end_date = as.character(Sys.Date()))[1,2]})
  observeEvent(input$logon,{
    updateNumericInput(session,'weight',value = latest_weight())
  })
  
  bmi_count = eventReactive(input$calculate,{(input$weight/(as.double(input$height)^2))*703})
  
  data = reactive({
    get_daily_data(cookie(),what = options$value,start_date = as.character(input$daterange[1]),
                   end_date = as.character(input$daterange[2]))})
  
  
  data_activity = reactive({
    get_activity_data(cookie(),end_date = as.character(input$daterange[2]))})
  
  data_activity_2 = reactive({data_activity() %>% select(5,11)})
  
  calory_sum = reactive({data_activity_2() %>% group_by(name) %>%summarize(calory =sum(calories)) %>% arrange(desc(calory))})
  
  top = reactive({calory_sum()$name[1]})
  
  
  data_calory = reactive({
    get_daily_data(cookie(),what = "caloriesBurnedVsIntake",start_date = as.character(input$daterange[1]),
                   end_date = as.character(input$daterange[2]))})
  data_sleep = reactive({
    get_sleep_data(cookie(),start_date = as.character(input$daterange[1]),
                   end_date = as.character(input$daterange[2]))[[2]]})
  
  data_sleep_2 = reactive({data_sleep() %>% select(1,5)})
  month = reactive({months(as.Date(data_sleep_2()$date))})
  
  
  data_heart = reactive({
    get_daily_data(cookie(),what = "getRestingHeartRateData",start_date = as.character(input$daterange[1]),
                   end_date = as.character(input$daterange[2]))})
  
  theme = theme_gray()+theme(axis.text = element_text(size = 12),
                             axis.title = element_text(size=16),
                             plot.title = element_text(size=20,face = 'bold',hjust = 0.5))
  
  
  
  #######################OUTPUT###################################### 
  
  output$bmi =renderText({paste0("Your BMI is  :",bmi_count())})  #eventReactive(input$logon, {print({bmi_count})})
  
  
  output$scatter = renderPlotly({plot_ly(data(),x=data()[,'time'],y=data()[,options$value],mode='lines') %>% layout(title=plt_title$value,
                                                                                                                    xaxis=list(title='Time'),                                                   yaxis=list(title=options$value))})
  
  
  
  
  observeEvent(input$logon,{output$calory_title =renderUI({h5("Total Burned Calories Breakdown By Activity",align="center")
  })})
  output$scatter_calory = renderPlotly({plot_ly(calory_sum(),x=~name,y=~calory,type="bar",color = ~name) %>% layout( xaxis=list(title="Activities"),y=list(title="Total Calories Burned"))})
  #ggplotly()})
  
  observeEvent(input$logon,{output$pie_title =renderUI({h5("Percentage BreakDown for Activities",align="center")
  })})
  output$pie_act = renderPlotly({plot_ly(data_activity(),labels=~name,values=~calories,type="pie") %>% layout(xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))})
  
  observeEvent(input$logon,{output$heart_title =renderUI({h5("Average Heart Rate per day",align="center")
  })})
  output$scatter_heart = renderPlotly({plot_ly(data_heart(),x=data_heart()[,'time'],y=data_heart()[,"restingHeartRate"],mode='lines',color = I('purple')) %>% layout(xaxis=list(title='Time'),yaxis=list(title="Resting Heart"))})
  
  observeEvent(input$logon,{output$sleep_title =renderUI({h5("Sleep summary for each Month",align="center")})})
  
  output$heartVsleep = renderPlotly({plot_ly(data_sleep_2(),y=~sleepDuration,type="box",color=~month()) %>% layout(yaxis=list(title="Sleep Minutes"))})
  
  observeEvent(input$calculate,{output$title_6 =renderUI({h5("BMI Comparison Plot",align="center")})})
  output$bmi_plot = renderPlotly({ plot_ly(x=~seq(9),y=~bmi_range,type = 'scatter',mode='text',text= ~body_type,color = ~body_type) %>% layout(shapes=list(type='line',x0=0,x1=8,y0=bmi_count(),y1=bmi_count(),yref="y",xref="x",line=list(color='blue')),xaxis=list(title=""),yaxis=list(title="BMI Count"))})
  

  
}

