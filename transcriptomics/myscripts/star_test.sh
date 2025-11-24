#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G
#SBATCH --time=00:10:00
#SBATCH --output=STAR_test.log

export PATH=$HOME/local/bin/STAR-2.7.10a/source:$PATH

which STAR
STAR --version
