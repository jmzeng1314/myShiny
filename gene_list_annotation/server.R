suppressPackageStartupMessages(library(shiny))
suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library(DT))
suppressPackageStartupMessages(library(stringr)  )
suppressPackageStartupMessages(library(clusterProfiler))
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
    gene_df=NULL, 
    kegg_df=NULL,
    species=NULL
  )
  
  reactiveValues.reset <-function(){
    glob_values$gene_df=NULL
    glob_values$species=NULL 
    glob_values$kegg_df=NULL
    
  }
  
  observeEvent(input$do,{
    reactiveValues.reset()
    log_cat(paste0('data', Sys.Date(),' ',IP()))
    
    db=ifelse(input$species == 'human','human_gene_info','mouse_gene_info')
    
    gene_list=NULL
    ## first check the upload file:
    inFile <- input$file1
    if ( ! is.null(inFile) ){ 
      gene_list=read.table(inFile$datapath, header=input$header)[,1] 
      
    } 
    ## Then check the text input area:
    if ( nchar(input$input_text) >5){
      gene_list  =  strsplit(input$input_text,'\n')[[1]] 
    }
    
    if( !is.null(gene_list)){
      con <- dbConnect(sqlite,"hg19_bioconductor.sqlite")  
      sql <- paste0('select * from ',db," where ",input$IDtype,
                    " in ('",paste0(gene_list,collapse = "','"),"')")
      glob_values$gene_df=dbGetQuery(con, sql)
      dbDisconnect(con)  
    }
    
  }) 
  output$gene_df <- DT::renderDataTable({
    if (! is.null(glob_values$gene_df)){
      dat=glob_values$gene_df
      dat$geneIds=createLink(paste0("http://www.ncbi.nlm.nih.gov/gene/",dat$geneIds),dat$geneIds) 
      dat
    }
    
    
    
  }  ,rownames= FALSE,escape = FALSE,options = list(  
    pageLength = 10, 
    lengthMenu = list(c(10, 50, 100,-1), c('10', '50','100', 'All'))
  )## end for options 
  )
  
})