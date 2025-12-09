#!/bin/bash
#SBATCH --job-name=STAR_map_all
#SBATCH --output=STAR_map_all_%j.out
#SBATCH --error=STAR_map_all_%j.err
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=200G
#SBATCH --mail-user=smdecker@uvm.edu
#SBATCH --mail-type=END,FAIL

export PATH=$HOME/local/bin/STAR-2.7.10a/source:$PATH

INDEX=/gpfs1/cl/ecogen/pbio6800/GroupProjects/SpicyTomates/star_index_chrys
READS=/gpfs1/cl/ecogen/pbio6800/GroupProjects/SpicyTomates/RawData/fastp_clean
OUTDIR=/gpfs1/cl/ecogen/pbio6800/GroupProjects/SpicyTomates/STAR_mapping_results

mkdir -p $OUTDIR

# Loop over all paired-end samples
for R1 in $READS/*_1_clean.fastq.gz; do
    SAMPLE=$(basename $R1 _1_clean.fastq.gz)
    R2=$READS/${SAMPLE}_2_clean.fastq.gz
    echo "Mapping sample $SAMPLE..."

    STAR --runThreadN 16 \
         --genomeDir $INDEX \
         --readFilesIn $R1 $R2 \
         --readFilesCommand zcat \
         --outFileNamePrefix $OUTDIR/${SAMPLE}_ \
         --outSAMtype BAM SortedByCoordinate \
         --quantMode GeneCounts
done
