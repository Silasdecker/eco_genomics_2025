#!/bin/bash
#SBATCH --job-name=STAR_index
#SBATCH --output=STAR_index.out
#SBATCH --error=STAR_index.err
#SBATCH --time=12:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=300G  
#SBATCH --cpus-per-task=16
#SBATCH --mail-user=smdecker@uvm.edu

export PATH=$HOME/local/bin/STAR-2.7.10a/source:$PATH

STAR --runThreadN 16 \
     --runMode genomeGenerate \
     --genomeDir /gpfs1/cl/ecogen/pbio6800/GroupProjects/SpicyTomates/star_index_chrys \
     --genomeFastaFiles /gpfs1/cl/ecogen/pbio6800/GroupProjects/SpicyTomates/RawData/CSE_r1.0.fa \
     --sjdbGTFfile /gpfs1/cl/ecogen/pbio6800/GroupProjects/SpicyTomates/RawData/CSE.gtf \
     --sjdbOverhang 149 \
     --limitGenomeGenerateRAM 250000000000
