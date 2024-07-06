library(shiny)
library(keepitsecret)

server <- function(input, output, session) {
  
  values <- reactiveValues()
  
  gen_pw <- eventReactive(input$generate, {
    if(input$method == "word"){
      values$pw <- keep_it_safe(input$method, input$n, input$cap, input$sep, min_size = input$min_size[1], max_size = input$min_size[2])
    } else if(input$method == "sentence"){
      values$pw <- keep_it_safe(input$method, input$n)
    } else if(input$method == "phrase"){
      values$pw <- keep_it_safe(input$method, input$n, input$sep)
    }
    
    print(values$pw)
  })
  
  safe <- eventReactive(input$generate, {
    values$safe <- is_it_safe(values$pw, verbose = F)
    print(values$safe$crack_times_display$online_no_throttling_10_per_second)
  })
  
  secret <- eventReactive(input$generate, {
    values$secret <- is_it_secret(values$pw)
    print(values$secret)
  })
  
  output$password <- renderText({
    gen_pw()
  })
  
  output$password_strength <- renderText({
    paste("Time to crack:", safe())
  })
  
  output$password_secrecy <- renderText({
    paste("Appearances in data breaches:", secret())
  })
}
