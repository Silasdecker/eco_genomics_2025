#!/bin/bash
#SBATCH --job-name=STAR_genome
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=200G
#SBATCH --time=04:00:00
#SBATCH --output=STAR_genome_%j.log

# Load STAR if using module (or use local path)
# module load STAR  # if STAR module is available
# Or add your local STAR to PATH
export PATH=$HOME/local/bin/STAR-2.7.10a/source:$PATH

# Run STAR genomeGenerate
STAR --runThreadN 8 \
     --runMode genomeGenerate \
     --genomeDir /gpfs1/cl/ecogen/pbio6800/GroupProjects/SpicyTomates/STARindex \
     --genomeFastaFiles /gpfs1/cl/ecogen/pbio6800/GroupProjects/SpicyTomates/RawData/GCA_019973895.1_Crys.fna
