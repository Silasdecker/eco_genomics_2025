#!/bin/bash   

# This script loops through a set of files defined by MYSAMP, matching left and right reads
# and cleans the raw data using fastp according to parameters set below

# Next, let's load our required modules:
module purge
module load gcc fastp

# Define the path to the transcriptomics folder in your Github repo.
MYREPO="/users/s/m/smdecker/projects/eco_genomics_2025"

# make a new directory within myresults/ to hold the fastp QC reports
mkdir ${MYREPO}/transcriptomics/myresults/Crys_fastp_reports_GP

# cd to the location (path) to the fastq data:

cd /gpfs1/cl/ecogen/pbio6800/GroupProjects/SpicyTomates/RawData

# Define the sample code to anlayze
# Be sure to replace with your 2-digit sample code

MYSAMP="SRR"

# for each file that has "MYSAMP" and "_1.fq.gz" (read 1) in the name
# the wildcard here * allows for the different reps to be captured in the list
# start a loop with this file as the input:

for READ1 in ${MYSAMP}*_1*.gz
do

# the partner to this file (read 2) can be found by replacing the _1.fq.gz with _2.fq.gz
# second part of the input for PE reads

READ2=${READ1/_1*.gz/_2*.gz}

# make the output file names: print the fastq name, replace _# with _#_clean

NAME1=$(echo $READ1 | sed "s/_1/_1_clean/g")
NAME2=$(echo $READ2 | sed "s/_2/_2_clean/g")

# print the input and output to screen 

echo $READ1 $READ2
echo $NAME1 $NAME2

# call fastp
fastp -i ${READ1} -I ${READ2} \
-o /gpfs1/cl/ecogen/pbio6800/GroupProjects/SpicyTomates/RawData/${NAME1} \
-O /gpfs1/cl/ecogen/pbio6800/GroupProjects/SpicyTomates/RawData/${NAME2} \
--detect_adapter_for_pe \
--trim_poly_g \
--thread 4 \
--cut_right \
--cut_window_size 6 \
--qualified_quality_phred 20 \
--length_required 35 \
--html ${MYREPO}/transcriptomics/myresults/fastp_reports/${NAME1}.html

done
