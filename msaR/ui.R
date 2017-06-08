library(shiny)
library(msaR)
# Define UI for random distribution application 
shinyUI(fluidPage(
  titlePanel("Visualization for the multiple sequence alignment result"),
  wellPanel(
    h3("please upload a ", code("aln")," format files"),
    p("please search aln format for details if you are not familar with it!"),
    fileInput('file1', 'Choose aln File',
              accept=c('aln', 
                       'text/comma-separated-values,text/plain', 
                       'aln')),
    actionButton("do", "Visualization for you aln file!", icon("paper-plane"), 
    style="color: #fff; background-color: #337ab7; border-color: #2e6da4"
    ),
    hr(),
    msaROutput('visual')
    
  )
))