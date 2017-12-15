# 欢迎试用我的shiny小工具 

首先需要安装一些必备的包：
```R
suppressPackageStartupMessages(library(org.Hs.eg.db))
suppressPackageStartupMessages(library(org.Mm.eg.db))
library(jsonlite)
library(msaR)
suppressMessages(library(RSQLite))
suppressPackageStartupMessages(library(DT))
suppressPackageStartupMessages(library(clusterProfiler))
suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library(ggseqlogo))
suppressPackageStartupMessages(library(shiny))
suppressPackageStartupMessages(library(shinyBS))
suppressPackageStartupMessages(library(shinyjs))
suppressPackageStartupMessages(library(stringr))
```

> 我本人非常喜欢R语言，也顺带喜欢shiny这样的展现方式，如果你想学，可以自己先看[一些例子](https://github.com/rstudio/shiny-examples)

## [基因ID转换](http://118.126.114.209:3838/jimmy/gene_list_annotation )
> 很简单，就是你复制粘贴一列基因名，就给你进行一些基因ID转换和注释，点击上面的目录就可以进入使用咯

## [KEGG的超几何分布检验](http://118.126.114.209:3838/jimmy/kegg_enrichment )
> 也就是通常人们说的KEGG富集分析,也很简单，同样点击上面的目录就可以进入使用咯

在输入框复制粘贴一列基因名，就给你富集的结果 

## [查看自己的IP](http://118.126.114.209:3838/jimmy/knowYourIP2/ )
> 这个没什么好说的，你点击就可以看到你的IP咯，运气好的话还可以定位你的学校或者城市。

## [多序列比对结果的可视化](http://118.126.114.209:3838/jimmy/msaR/)
> 上传你的aln文件格式的多序列比对结果文件即可,[点击下载测试数据](http://118.126.114.209:3838/jimmy/msaR/AHBA.aln)

## [序列motif类似的logo图](http://118.126.114.209:3838/jimmy/seqlogo/)
> 在输入框粘贴多条DNA/氨基酸序列即可，一条序列一行,就可以给你创建一个motif类似的logo图，其实就是显示每个位点的碱基/氨基酸的出现频率。












