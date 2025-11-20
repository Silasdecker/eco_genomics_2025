#!/bin/bash
#SBATCH --job-name=gz_fastq
#SBATCH --output=/gpfs1/cl/ecogen/pbio6800/GroupProjects/SpicyTomates/RawData/gzip_%j.out
#SBATCH --partition=general
#SBATCH --mail-type=ALL
#SBATCH --mail-user=smdecker@uvm.edu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=64G
#SBATCH --time=24:00:00

# Move to the directory containing the FASTQs
cd /gpfs1/cl/ecogen/pbio6800/GroupProjects/SpicyTomates/RawData

echo "Starting gzip job on $(hostname) at $(date)"
echo "Current directory:"
pwd
echo "Files to compress:"
ls -lh *.fastq

# Compress all FASTQs in parallel using pigz (multi-core gzip)
# If pigz is not available, fall back to standard gzip
if command -v pigz &> /dev/null
then
    echo "Using pigz for multi-core compression"
    pigz -p $SLURM_CPUS_PER_TASK *.fastq
else
    echo "pigz not found, using standard gzip (single-core)"
    for fq in *.fastq; do
        gzip "$fq"
    done
fi

echo "Compression finished at $(date)"
echo "Compressed files:"
ls -lh *.fastq.gz
