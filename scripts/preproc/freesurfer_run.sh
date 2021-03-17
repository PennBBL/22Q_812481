#!/bin/bash


#ssh singularity01
# run from  project/bbl_projects/22Q dir


unset SINGULARITYENV_TMPDIR
export SINGULARITYENV_FS_LICENSE=~/22Q/images/license.txt
export SINGULARITYENV_SUBJECTS_DIR=~/22Q/data/freesurfer
export SINGULARITYENV_INPUT_DIR=~/22Q/data/bids_directory/sub-17867/ses-22Q1/anat

singularity exec --cleanenv \
recon-all -s sub-17867 -i $INPUT_DIR/sub-17867_ses-22Q1_T1w.nii.gz -all

