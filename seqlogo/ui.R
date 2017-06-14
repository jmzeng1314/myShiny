suppressPackageStartupMessages(library(shiny))
suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library(DT))
suppressPackageStartupMessages(library(stringr)  )
suppressPackageStartupMessages(library(ggseqlogo))
suppressPackageStartupMessages(library(shinyjs))
data(ggseqlogo_sample) 
seqs_dna$sample_dna_3
sp <- sidebarPanel( 
  h3("Type a list of sequence(DNA/AA)"),
  tags$style(type="text/css", "textarea {width:100%}"),
  tags$textarea(id = 'input_text', 
                placeholder = "GATGAGTCATA\nGATGAGTCATA\nGATGAGTCACA", 
                rows = 8, ''),	
  hr(), 
  a('example input:',href='DNA.seq.txt'),
  hr(),
  actionButton("do", "analysis", icon("paper-plane"), 
               style="color: #fff; background-color: #337ab7; border-color: #2e6da4"
  )  ,
  hr(), 
  tags$img(src = "http://www.bio-info-trainee.com/wp-content/uploads/2016/09/jimmy-donate.jpg", 
           width = "300px", height = "300px")
)

mp <- mainPanel(
  plotOutput('logo')
)

shinyUI(
  fluidPage(
    tags$script(src="getIP.js"),
    titlePanel('seqlogo motif:'),
    sidebarLayout(
      sidebarPanel = sp,
      mainPanel = mp
    )
  )
)

