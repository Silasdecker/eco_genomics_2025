

# Population Genomics Notebook

## Fall 2025 Ecological Genomics

## Author: Silas Decker

### 9/11/25: Cleaning FastQ reads of red spruce

-   We wrote a bash script called fastp.sh located within my Github Repo: `~/projects/eco_genomics_2025/population_genomics/myscripts`

the myscripts folder This was used to trim adapters off red spruce fastq sequence files.

-   Raw fastq files were located on the class share space: `/gpsfs1/cl/ecogen/pbio6800/PopulationGenomics/fastq/red_spruce`

-   Using the program fastp we processed the raw reads and cleaned and output the cleaned reads to the following directory on the class shared space `/gpsfs1/cl/ecogen/pbio6800/PopulationGenomics/cleanreads`

-   Fastp produced html formatted reports for each sample which I saved into the directory:

`~/projects/eco_genomics_2025/population_genomics/myresults/fastp_reports`

-   The results showed high quality sequence with most Q-scores \>\>20 and low amount of adaptor contamination. We also trimmed the first 12 bp to get rid of barcoded indicies

-   Cleaned reads are now ready to proceed to the next step in our pipeline: mapping to the reference genome!

### 9/16/2025: Mapping Cleaned Reads to the Reference Genome! 
* note my population is 2022
* we used clean reads to map to black spruce reference genome using bwa-mem2
* We will go to the reference genome via: 
`cd /gpfs1/cl/ecogen/pbio6800/PopulationGenomics/ref_genome`
* the reference genome is provided here: 
`/users/s/m/smdecker/projects/eco_genomics_2025/population_genomics`
* we modified the mapping.sh script to our specific population samples and saved resulting sequence files (.sam) to the class shared space: 
`/gpfs1/cl/ecogen/pbio6800/PopulationGenomics/bams`
* We submitted to the VACC SLURM scheduler using sbatch requesting 10 cpus and 64 GB ram 
* some nodes would not compute so we had to run a few times until no more failure 

* While it was running we produced process_bam.sh and bam_stats.sh files and combined them in a wrapper (process_stats_wrapper.sh)
* The bam_stats.sh script generates stats regarding bwa alignment and the output is:
`~/projects/eco_genomics_2025/population_genomics/myscripts`
* process_bam.sh will use the program sambamba to manipulate sam/bam files 
* Sambamba will do several steps, including removing PCR duplicates and index the process file for quick lookup
* We submitted the wrapped job to SLURM and the output of the wrapped script will be in:
`~/projects/eco_genomics_2025/population_genomics/myscripts`

* Finally, we visualized the mapping of our reads to the reference via tview which is part of samtools

module load gcc samtools 

samtools tview \
/gpfs1/cl/ecogen/pbio6800/PopulationGenomics/examples/2030_57_O.sorted.rmdup.bam \
/gpfs1/cl/ecogen/pbio6800/PopulationGenomics/ref_genome/Pmariana/Pmariana1.0-genome_reduced.fa


### 9/18/2025  Review Bamstats and set up nucleotide diversity estimation using ANGSD

* Load in 2022.stats.txt into r to view

* Wrote short script called bam_stats_review.r located in myscripts to evaluate the mapping success 
* saw roughly 66% reads mapped in proper pairs 
* obtained depth of coverage between 2-3x , suggest we need to use a probabilistic framework for analyzing the genotype data

* We used the program Analysis of Next Generation Sequence Data (ANGSD) to perform genotype likelihood (GL) analysis
* GL is the probability of observing the sequencing data given the genotype of the individual at that site 
* To do so we made a bash script called ANGSD.sh which estimated genotype liklihoods (GLs) and allele frequencies 
* ANGSD.sh also filtered for base and mapping quality as well as sequencing depth 

* In addition to ANGSD.sh we made a bash script to estimate nucleotide diversity (theta) called ANGSD_doTheta.sh
* To run the two ANGSD scripts in series, we made a wrapper called diversity_wrapper.sh and submitted it to SLURM with outputs in diversity (ANGSD_doTheta.sh) and ANGSD (ANGSD.sh):
`/users/s/m/smdecker/projects/eco_genomics_2025/population_genomics/myresults/ANGSD/diversity`
`/users/s/m/smdecker/projects/eco_genomics_2025/population_genomics/mydata/ANGSD`
* Stats derived from these scripts include: Watterson's Theta (tW), Tajima's D (Tajima), and Theta pi (tP)
* Additional information produced includes 'Chr' (the chromosome/contig a read maps to), WinCenter (center of window/contig in bp), and nSites (number of bp being analyzed)

### 9/23/25

* We made an Rmarkdown file called Nucleotide_Diversity.Rmd that lives in: 
`/users/s/m/smdecker/projects/eco_genomics_2025/population_genomics/mydocs`

* To compare our individual samples to the entire class samples we filled in a good sheet:
* https://docs.google.com/spreadsheets/d/1SLwhW3OgQiX2z1rxH-ske236NYxjDXCvUu0l8XFeS_w/edit?usp=sharing
* This sheet will be used to compare diversity across samples

* The Nucleotide_Diversity.Rmd file began by reading in our theta values
* We then scaled the Watterson's theta values by nSites and used the library tidyverse to filter out reads where nSites<100
* We summarized out new filtered dataframe (theta2) to produce statistics for aforementioend numbers produced in the diversity_wrapper.sh file
* Using the library ggplot2 we produced a histogram of how many sites are in each window 

* We also used ggplot to plot nucleotide diversity in our population for 50 kB windows 
* To interrogate the data for evidence of selective sweeps (large negative Tajima and low nucleotide diversity):
* theta2[which(theta2$Tajima < -1.5 & theta2$tPsite<0.001),]

* We solved for the effective population size using the mutation rate, ploidy, regeneration time, and theta
* We then pulled out extreme values for Tajima's D using max and min functions 

### 9/25/25

* We wrote a bash script to compare Fst between our red spruce and Wisconsin black spruce, called ANGSD_Fst.sh and the file produced results to:
`/users/s/m/smdecker/projects/eco_genomics_2025/population_genomics/myresults/ANGSD/Fst`

* We then wrote a bash script to run PCA and admixture for ALL samples called PCAngsd_RSBS.sh
* My script is not running right now, I am in the process of debugging and will update my notebook accordingly 





