#!/bin/bash
#SBATCH --partition=general
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=120G
#SBATCH --time=12:00:00
#SBATCH --job-name=STAR_map_geneCounts
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

# --- Step 1: Map reads & generate STAR GeneCounts ---
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
         --quantMode GeneCounts \
         2> "${PROJECT_DIR}/logs/${sample}.STAR.stderr" \
         1> "${PROJECT_DIR}/logs/${sample}.STAR.stdout"

    if [ ! -s "${BAM}" ]; then
        echo "WARNING: ${BAM} empty. See logs."
        continue
    fi

    echo "Finished mapping ${sample}. STAR gene counts in ${OUTPREFIX}ReadsPerGene.out.tab"
done

# --- Step 2: Merge STAR GeneCounts for DESeq2 ---
cd "${PROJECT_DIR}"
MERGED_COUNTS="merged_gene_counts.txt"
echo "Merging STAR ReadsPerGene.out.tab files into ${MERGED_COUNTS}..."

FIRST=1
for F in *_ReadsPerGene.out.tab; do
    if [ $FIRST -eq 1 ]; then
        awk '{print $1}' "$F" > "$MERGED_COUNTS"  # gene IDs
        FIRST=0
    fi
    cut -f2 "$F" > "${F}.counts"
done

paste *_ReadsPerGene.out.tab.counts | awk 'BEGIN{OFS="\t"}{print $0}' >> "$MERGED_COUNTS"

echo "Merged counts written to ${MERGED_COUNTS}. Ready for DESeq2."
