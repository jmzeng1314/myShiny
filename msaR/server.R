library(shiny) 
library(msaR)
shinyServer(function(input, output,session) { 
  output$visual <- renderMsaR({ 
    input$do
    inFile <- input$file1
    msaFile=ifelse(is.null(inFile)
                   ,'AHBA.aln'
                   ,inFile$datapath)
    msaR(msaFile)
  })
})