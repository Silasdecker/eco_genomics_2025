---
title: "PCA_Admix"
author: "Silas Decker"
date: "2025-09-25"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

```{r}
knitr::opts_chunk$set(echo = TRUE)
knitr::opts_knit$set(root.dir="~/projects/eco_genomics_2025/population_genomics/myresults/ANGSD/PCA_ADMIX/") 
```

## R Markdown
Load Libraries for Plotting

```{r}
library(ggplot2)
library(ggpubr)
```
First Lets estimate PCA!

```{r}
COV<-as.matrix(read.table('RSBS_poly_K2.cov'))
PCA<-eigen(COV)
```
How much variance does the first eigenvalue explain 

```{r}
var<-round(PCA$values/sum(PCA$values),3)
var[1:3]



```
Scree plot of the variance explained (barplot of variance explained with excessivelt high eigenvalues )

```{r}
barplot(var, 
        xlab="Eigenvalues of the PCA", 
        ylab="Proportion of variance explained")
```

Good ole data wrangling 
Takes the names of our samples and makes them into tidy format 

```{r}
names <- read.table("RSBS_bam.list")
names <- unlist(strsplit(basename(as.character(names[,1])), split = ".sorted.rmdup.bam"))
split = strsplit(names, "_")
pops <- data.frame(names[1:113], do.call(rbind, split[1:113]))
names(pops) = c("Ind", "Pop", "Row", "Col")

data=as.data.frame(PCA$vectors)
data=data[,c(1:3)]
data= cbind(data, pops)
```
```{r}
ggscatter(data, x = "V1", y = "V2",
          color = "Pop",
          mean.point = TRUE,
          star.plot = TRUE,
          main="Red spruce-Black spruce genetic PCA") +
  theme_bw(base_size = 13, base_family = "Times") +
  labs(x = paste0("PC1: (",var[1]*100,"%)"), y = paste0("PC2: (",var[2]*100,"%)"))
```

What about admixture analysis
```{r}
q <- read.table("RSBS_poly.admix.2.Q", sep=" ", header=F)

K=dim(q)[2] #Find the level of K modeled

## rank order the samples according to population code
ord<-order(pops[,2])


```

Plot the admixture coefficients 
```{r}
barplot(t(q)[,ord],
        #col=cols[1:K],
        col=c("black","red"),
        space=0,border=NA,
        xlab="Populations",ylab="Admixture proportions",
        main=paste0("Red Spruce-Black Spruce Admixture: K=",K))
text(tapply(1:nrow(pops),pops[ord,2],mean),-0.05,unique(pops[ord,2]),xpd=T,cex=0.75,srt=45)
abline(v=cumsum(sapply(unique(pops[ord,2]),function(x){sum(pops[ord,2]==x)})),col=1,lwd=1.2)
```

