#!/bin/bash

subject=17867
project=/project/bbl_projects/22Q

SIF=${project}/images/fmriprep_latest.sif
#BIDSDIR=${project}/data/bids_directory
TMPDIR=${project}/tmp

singularity run --cleanenv \
  -B ${project}:/mnt \
  -B ${project}/tmp:/tmp \
  ${SIF} \
  /mnt/data/bids_directory /mnt/data/fmriprep participant \
  --work-dir /tmp \
  --participant_label $subject \
  --fs-license-file /mnt/images/license.txt \
  --stop-on-first-crash \
  --skip-bids-validation \
  --verbose
