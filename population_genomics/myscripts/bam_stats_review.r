# Reviewing our bamstats 
getwd()
setwd('population_genomics/myresults/')

stats<-read.table('2022.stats.txt', header = T, sep='')
View(stats)

stats$pctPaired = stats$Num_Paired/stats$Num_reads

