#!/bin/bash

#SBATCH -A iPlant-Collabs
#SBATCH -p normal
#SBATCH -t 24:00:00
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -J prdgltst
#SBATCH --mail-type BEGIN,END,FAIL
#SBATCH --mail-user kyclark@email.arizona.edu

set -u

./run.sh -q /work/05066/imicrobe/iplantc.org/data/imicrobe/projects/1/samples/1/JGI_AMD_5WAY_IRNMTN_SMPL_20020301.fa -o $SCRATCH/prodigal-test
