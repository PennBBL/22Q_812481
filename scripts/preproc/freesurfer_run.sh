#!/bin/bash

unset SINGULARITYENV_TMPDIR
export SINGULARITYENV_FS_LICENSE=/project/bbl_projects/22Q/images/license.txt
export SINGULARITYENV_SUBJECTS_DIR=/project/bbl_projects/22Q/data/freesurfer

singularity exec --cleanenv  /project/bbl_projects/22Q/images/freesurfer_7.1.1.sif \
recon-all -s sub-17867 -i /project/bbl_projects/22Q/data/bids_directory/sub-17867/ses-22Q1/anat/sub-17867_ses-22Q1_T1w.nii.gz -all

