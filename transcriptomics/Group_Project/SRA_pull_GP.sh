#!/bin/bash
#SBATCH --job-name=SRA_pull_GP

# Name the output file: Re-direct the log file to your home directory
# The first part of the name (%x) will be whatever you name your job 
#SBATCH --output=/gpfs1/cl/ecogen/pbio6800/GroupProjects/SpicyTomates/RawData/SRA_pull.out

# Which partition to use: options include short (<3 hrs), general (<48 hrs), or week
#SBATCH --partition=general

# Specify when Slurm should send you e-mail.  You may choose from
# BEGIN, END, FAIL to receive mail, or NONE to skip mail entirely.
#SBATCH --mail-type=ALL
#SBATCH --mail-user=smdecker@uvm.edu

# Run on a single node with four cpus/cores and 8 GB memory
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=64G

# Time limit is expressed as days-hrs:min:sec; this is for 24 hours.
#SBATCH --time=24:00:00

#---------  End Slurm preamble, job commands now follow

OUTDIR="/gpfs1/cl/ecogen/pbio6800/GroupProjects/SpicyTomates/RawData"

prefetch SRR15057665 --output-directory /gpfs1/cl/ecogen/pbio6800/GroupProjects/SpicyTomates/RawData

prefetch SRR15057666 --output-directory /gpfs1/cl/ecogen/pbio6800/GroupProjects/SpicyTomates/RawData

prefetch SRR15057667 --output-directory /gpfs1/cl/ecogen/pbio6800/GroupProjects/SpicyTomates/RawData

prefetch SRR15057668 --output-directory /gpfs1/cl/ecogen/pbio6800/GroupProjects/SpicyTomates/RawData

prefetch SRR15057669 --output-directory /gpfs1/cl/ecogen/pbio6800/GroupProjects/SpicyTomates/RawData

prefetch SRR15057670 --output-directory /gpfs1/cl/ecogen/pbio6800/GroupProjects/SpicyTomates/RawData