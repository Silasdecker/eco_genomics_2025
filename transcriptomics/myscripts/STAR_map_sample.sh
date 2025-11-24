#!/bin/bash
#SBATCH --partition=general
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=50G
#SBATCH --time=06:00:00
#SBATCH --job-name=STAR_singleSample
#SBATCH --output=~/single_sample/star_single.%j.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user=smdecker@uvm.edu

set -euo pipefail

# --- Paths ---
FASTP_DIR=~/single_sample
PROJECT_DIR=~/single_sample
STARINDEX=/gpfs1/cl/ecogen/pbio6800/GroupProjects/SpicyTomates/STARindex
GENOME_FASTA=/gpfs1/cl/ecogen/pbio6800/GroupProjects/SpicyTomates/RawData/GCA_019973895.1_Crys.fna

export PATH=$HOME/local/bin/STAR-2.7.10a/source:$PATH

mkdir -p "${PROJECT_DIR}/logs"

# --- Sample files ---
F1="${FASTP_DIR}/SRR15057665_1_clean.fastq.gz"
F2="${FASTP_DIR}/SRR15057665_2_clean.fastq.gz"
SAMPLE="SRR15057665"
OUTPREFIX="${PROJECT_DIR}/${SAMPLE}_"

# --- Run STAR ---
echo "Mapping ${SAMPLE}..."
STAR --runThreadN 16 \
     --genomeDir "${STARINDEX}" \
     --readFilesIn "${F1}" "${F2}" \
     --readFilesCommand zcat \
     --outFileNamePrefix "${OUTPREFIX}" \
     --outSAMtype BAM SortedByCoordinate \
     --quantMode GeneCounts \
     2> "${PROJECT_DIR}/logs/${SAMPLE}.STAR.stderr" \
     1> "${PROJECT_DIR}/logs/${SAMPLE}.STAR.stdout"

echo "Finished mapping ${SAMPLE}. STAR gene counts in ${OUTPREFIX}ReadsPerGene.out.tab"
