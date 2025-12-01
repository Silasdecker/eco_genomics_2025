#!/bin/bash
#SBATCH --job-name=counts_matrix_STAR
#SBATCH --output=STAR_counts_matrix_all_%j.out
#SBATCH --error=STAR_map_all_%j.err
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=200G
#SBATCH --mail-user=smdecker@uvm.edu
#SBATCH --mail-type=END,FAIL

cd /gpfs1/cl/ecogen/pbio6800/GroupProjects/SpicyTomates/STAR_mapping_results

# Create counts matrix:
echo "Generating counts matrix..."

# Extract the gene column from the first file
first_file=$(ls *_ReadsPerGene.out.tab | head -n 1)
cut -f1 $first_file > gene_ids.txt

# Loop through each ReadsPerGene file and extract column 2 
for file in *_ReadsPerGene.out.tab; do
    sample=$(basename $file _ReadsPerGene.out.tab)
    echo "Processing $sample ..."
    cut -f2 $file > ${sample}.counts
done

# Paste together: gene IDs + all sample count columns
paste gene_ids.txt *.counts > STAR_counts_matrix.tsv

# Add header
header="GeneID"
for file in *_ReadsPerGene.out.tab; do
    sample=$(basename $file _ReadsPerGene.out.tab)
    header="${header}\t${sample}"
done

# Prepend header to file
echo -e $header | cat - STAR_counts_matrix.tsv > STAR_counts_matrix_with_header.tsv

echo "DONE! Matrix = STAR_counts_matrix_with_header.tsv"
