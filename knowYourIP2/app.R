library(shiny)
require(RJSONIO)    
require(DT)    


ui <- fluidPage(titlePanel("我知道你的IP地址哦"), 
                tags$head(
                  tags$script(src="getIP.js")
                ),
                hr(),
                DT::dataTableOutput('tmp')
)

server <- function(input, output) {
  IP <- reactive({ input$getIP })
  
  output$tmp <- DT::renderDataTable({ 
      do.call("rbind", IP()) 

  })
}
shinyApp(ui, server)
# library(jsonlite) 
# json_file = "projectslocations.html"
# json_datan <- fromJSON(json_file)