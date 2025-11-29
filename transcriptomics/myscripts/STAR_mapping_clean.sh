#!/bin/bash
#SBATCH --partition=general
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=120G
#SBATCH --time=12:00:00
#SBATCH --job-name=STAR_map_BAM
#SBATCH --output=/gpfs1/cl/ecogen/pbio6800/GroupProjects/SpicyTomates/RawData/star_map.%j.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user=smdecker@uvm.edu

set -euo pipefail

# --- Paths ---
FASTP_DIR=/gpfs1/cl/ecogen/pbio6800/GroupProjects/SpicyTomates/RawData/fastp_clean
PROJECT_DIR=/gpfs1/cl/ecogen/pbio6800/GroupProjects/SpicyTomates/RawData
STARINDEX=/gpfs1/cl/ecogen/pbio6800/GroupProjects/SpicyTomates/STARindex

export PATH=$HOME/local/bin/STAR-2.7.10a/source:$PATH

mkdir -p "${PROJECT_DIR}/logs"

# --- Step 1: Map reads (no gene counts) ---
cd "${FASTP_DIR}"

for F1 in *_1_clean.fastq.gz; do
    [ -e "$F1" ] || { echo "No cleaned FASTQs found; exiting."; exit 1; }

    F2=${F1/_1_clean/_2_clean}
    sample=${F1%_1_clean.fastq.gz}
    OUTPREFIX="${PROJECT_DIR}/${sample}_"

    BAM="${OUTPREFIX}Aligned.sortedByCoord.out.bam"
    if [ -s "${BAM}" ]; then
        echo "Skipping ${sample}: BAM exists."
        continue
    fi

    echo "==== Mapping ${sample} ===="
    STAR --runThreadN 16 \
         --genomeDir "${STARINDEX}" \
         --readFilesIn "${FASTP_DIR}/${F1}" "${FASTP_DIR}/${F2}" \
         --readFilesCommand zcat \
         --outFileNamePrefix "${OUTPREFIX}" \
         --outSAMtype BAM SortedByCoordinate \
         2> "${PROJECT_DIR}/logs/${sample}.STAR.stderr" \
         1> "${PROJECT_DIR}/logs/${sample}.STAR.stdout"

    if [ ! -s "${BAM}" ]; then
        echo "WARNING: ${BAM} empty. See logs."
        continue
    fi

    echo "Finished mapping ${sample}. BAM in ${BAM}"
done

echo "All samples mapped. BAM files ready for downstream counting (e.g., featureCounts)."
