suppressPackageStartupMessages(library(shiny))
suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library(DT))
suppressPackageStartupMessages(library(stringr)  )
suppressPackageStartupMessages(library(clusterProfiler))
suppressPackageStartupMessages(library(shinyjs))
suppressPackageStartupMessages(library(shinyBS))

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
      if(length(gene_list) < 20){
        createAlert(session, "alert_ui_anchorId", "exampleAlert", title = "Oops",
                    content = " 你给的基因数量少于20，没啥意思，不给你富集了 ！", append = FALSE)
      }else if(length(gene_list) > 2000 ){
        createAlert(session, "alert_ui_anchorId", "exampleAlert", title = "Oops",
                    content = " 给我多于2000个基因，我的服务器受不了呀，要不你先捐赠一下呗  ", append = FALSE)
      }else{
        closeAlert(session, "exampleAlert")
        gene_list=unique(gene_list)
        con <- dbConnect(sqlite,"hg19_bioconductor.sqlite")  
        sql <- paste0('select * from ',db," where ",input$IDtype,
                      " in ('",paste0(gene_list,collapse = "','"),"')")
        glob_values$gene_df=dbGetQuery(con, sql)
        dbDisconnect(con)  
        if (T ){ ## for kegg 
          suppressPackageStartupMessages(library(org.Mm.eg.db))
          suppressPackageStartupMessages(library(org.Hs.eg.db))
          
          gene_df = glob_values$gene_df
          ############################################################
          ############  gene ID transfer #############################
          ############################################################ 
          
          gene_list <- gene_df$symbol  
          
          gene.df=''
          if(input$species == 'human'){
            gene.df <- bitr(gene_list, fromType = "SYMBOL",
                            toType = c("ENSEMBL", "ENTREZID"),
                            OrgDb = org.Hs.eg.db )
            ego <- enrichKEGG(gene         = gene.df$ENTREZID,
                              organism     = 'hsa',
                              pvalueCutoff = 0.99,
                              qvalueCutoff=0.99
            )
            ego <- setReadable(ego, OrgDb = org.Hs.eg.db, keytype="ENTREZID")
          }else{
            gene.df <- bitr(gene_list, fromType = "SYMBOL",
                            toType = c("ENSEMBL", "ENTREZID"),
                            OrgDb = org.Mm.eg.db )
            ego <- enrichKEGG(gene         = gene.df$ENTREZID,
                              organism     = 'mmu',
                              pvalueCutoff = 0.99,
                              qvalueCutoff=0.99
            )
            ego <- setReadable(ego, OrgDb = org.Mm.eg.db, keytype="ENTREZID")
          }
          
          glob_values$kegg_df <- as.data.frame(ego)
          
        }  ## for kegg 
      }}  ##  if( !is.null(gene_list)){
    
    
    
    
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
  
  output$KEGG_df <- DT::renderDataTable({
    if (! is.null(glob_values$kegg_df))
      glob_values$kegg_df
  }  ,rownames= FALSE,options = list(
    pageLength = 10,
    lengthMenu = list(c(10, 50, 100,-1), c('10', '50','100', 'All'))
    ,
    
    scrollX = TRUE,
    fixedHeader = TRUE,
    fixedColumns = TRUE ,
    deferRender = TRUE
  ),
  #filter = 'top',
  escape = FALSE
  )
  
})