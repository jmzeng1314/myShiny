suppressPackageStartupMessages(library(shiny))
suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library(DT))
suppressPackageStartupMessages(library(stringr)  )
suppressPackageStartupMessages(library(clusterProfiler))
suppressPackageStartupMessages(library(shinyjs))

sp <- sidebarPanel(
  #h5("choose the ID type:"),
  selectInput("IDtype",
              label = "choose the ID type",
              choices = c("HUGO Gene Symbol"  = "symbols",
                          "Entrez Gene ID" 	= "geneIds", 
                          "ENSEMBL Gene ID"	= "geneEnsembl")),
  ##  "symbols"     "geneIds"     "geneNames"   "geneEnsembl" "geneMap"     "geneAlias"
  h3("Type the Gene List:"),
  tags$style(type="text/css", "textarea {width:100%}"),
  tags$textarea(id = 'input_text', 
                placeholder = "TP53\nCBX6", 
                rows = 8, ''),	
  hr(), 
  # h5("Please unload a file containing the Gene List"),
  # fileInput('file1', 'Choose txt File',
  #           accept=c('text/csv', 
  #                    'text/comma-separated-values,text/plain', 
  #                    '.txt')), 
  # checkboxInput('header', 'Header or not', FALSE), 
  radioButtons("species", "Select a species:",
               c("human(Homo sapiens)"="human",
                 "mouse(Mus Musculus)"="mouse" ),
               selected = 'human' 
  ), 
  hr(), 
  actionButton("do", "analysis", icon("paper-plane"), 
               style="color: #fff; background-color: #337ab7; border-color: #2e6da4"
  )  ,
  hr(),
  p('如果你觉得这个工具有用，捐赠一下吧，我可以升级服务器'),
  tags$img(src = "http://www.bio-info-trainee.com/wp-content/uploads/2016/09/jimmy-donate.jpg", 
           width = "300px", height = "300px")
)

mp <- mainPanel(
  h3('Gene Annotation result:'),
  DT::dataTableOutput('gene_df'), 
  hr() 
)

shinyUI(
  fluidPage(
    tags$script(src="getIP.js"),
    titlePanel('Gene List Annotation'),
    sidebarLayout(
      sidebarPanel = sp,
      mainPanel = mp
    )
  )
)

