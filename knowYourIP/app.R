library(shiny)
ui <- fluidPage(titlePanel("我知道你的IP地址哦"), 
                tags$iframe(src='https://ipinfo.io/', height='1200', width='100%')           
)

server <- function(input, output) {
  
}
shinyApp(ui, server)

 
# 
# ui <- fluidPage(titlePanel("Getting Iframe"), 
#                 sidebarLayout(
#                   sidebarPanel(
#                     fluidRow(
#                       column(6, selectInput("Member", label=h5("Choose a option"),choices=c('BCRA1','FITM2'))
#                       ))),
#                   mainPanel(fluidRow(
#                     htmlOutput("frame")
#                   )
#                   )
#                 ))
# 
# server <- function(input, output) {
#   observe({ 
#     query <- members[which(members$nr==input$Member),2]
#     test <<- paste0("http://news.scibite.com/scibites/news.html?q=GENE$",query)
#   })
#   output$frame <- renderUI({
#     input$Member
#     my_test <- tags$iframe(src=test, height=600, width=535)
#     print(my_test)
#     my_test
#   })
# }