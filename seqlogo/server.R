suppressPackageStartupMessages(library(shiny))
suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library(DT))
suppressPackageStartupMessages(library(stringr)  )
suppressPackageStartupMessages(library(ggseqlogo))
suppressPackageStartupMessages(library(shinyjs))

suppressMessages(library(RSQLite)) 
sqlite    <- dbDriver("SQLite")

createLink <- function(base,val) {
  sprintf('<a href="%s" class="btn btn-link" target="_blank" >%s</a>',base,val) ##target="_blank" 
}


log_cat <- function(info='hello world~',file='log.txt'){
  cat(as.character(Sys.time()),info ,"\n",file=file,append=TRUE)
}


shinyServer(function(input, output,session) { 
  
  IP <- reactive({ 
    tmp<-input$getIP 
    as.character(tmp$ip)
  })
  
  #log_cat(paste0('data', Sys.Date(),IP()))
  
  
  glob_values <- reactiveValues(
    seqs=NULL, 
    kegg_df=NULL,
    species=NULL
  )
  
  reactiveValues.reset <-function(){
    glob_values$seqs=NULL
    glob_values$species=NULL 
    glob_values$kegg_df=NULL
    
  }
  
  observeEvent(input$do,{
    reactiveValues.reset()
    log_cat(paste0('data', Sys.Date(),' ',IP()))
    
    db=ifelse(input$species == 'human','human_gene_info','mouse_gene_info')
    
    seqs=NULL 
    ## Then check the text input area:
    if ( nchar(input$input_text) >5){
      seqs  =  strsplit(input$input_text,'\n')[[1]] 
    }
    
    if( !is.null(seqs)){ 
      glob_values$seqs=seqs
    }else{
      data(ggseqlogo_sample)
      glob_values$seqs=seqs_dna$sample_dna_3
    }
    
  }) 
  
  output$logo <- renderPlot({
    if(!is.null(glob_values$seqs))
      ggseqlogo( glob_values$seqs )
  })
  
})