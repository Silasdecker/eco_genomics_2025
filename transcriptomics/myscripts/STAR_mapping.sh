#!/bin/sh
#SBATCH --partition=general
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=120G
#SBATCH --time=8:00:00 
#SBATCH --job-name=STAR_mapping
#SBATCH --output=/gpfs1/cl/ecogen/pbio6800/GroupProjects/SpicyTomates/RawData/star_map.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user=smdecker@uvm.edu

# Load STAR if needed, or add your local STAR to PATH
# module load STAR
export PATH=$HOME/local/bin/STAR-2.7.10a/source:$PATH

# Go to folder with FASTQs
cd /gpfs1/cl/ecogen/pbio6800/GroupProjects/SpicyTomates/RawData

# Loop over all paired FASTQs
for F1 in *_1*.fastq.gz; do
    F2=${F1/_1/_2}
    sample=${F1%_1*.fastq.gz}

    echo "Mapping $sample ..."

    STAR --runThreadN 16 \
         --genomeDir /gpfs1/cl/ecogen/pbio6800/GroupProjects/SpicyTomates/STARindex \
         --readFilesIn $F1 $F2 \
         --readFilesCommand zcat \
         --outFileNamePrefix ${sample}_ \
         --outSAMtype BAM SortedByCoordinate
done

# Optional: generate counts matrix
featureCounts -T 8 \
              -a Crys_exon.gtf \
              -o gene_counts.txt \
              *_Aligned.sortedByCoord.out.bam
