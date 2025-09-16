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
* We will go to the reference genome via: 
`cd /gpfs1/cl/ecogen/pbio6800/PopulationGenomics/ref_genome`

