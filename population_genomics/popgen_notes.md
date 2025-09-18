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
* the reference genome is provided here: 
`/users/s/m/smdecker/projects/eco_genomics_2025/population_genomics`
* we modified the mapping.sh script to our specific population samples and saved resulting sequence files (.sam) to the class shared space: 
`/gpfs1/cl/ecogen/pbio6800/PopulationGenomics/bams`
* We submitted to the VACC SLURM scheduler using sbatch requesting 10 cpus and 64 GB ram 
* some nodes would not compute so we had to run a few times until no more failure 
* While it was running we produced process_bam.sh and bam_stats.sh files and combined them in a wrapper (process_stats_wrapper.sh)




* We will go to the reference genome via: 
`cd /gpfs1/cl/ecogen/pbio6800/PopulationGenomics/ref_genome`

### 9/18/2025  Review Bamstats and set up nucleotide diversity estimation using ANGSD

* Load in 2022.stats.txt into r to view

* Wrote short script called bam_stats_review.r located in myscripts to evaluate the mapping success 
* saw roughly 66% reads mapped in proper pairs 
* obtained depth of coverage between 2-3x , suggest we need to use a probabilistic framework for analyzing the genotype data

* 

