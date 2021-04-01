#!/bin/bash

project=/project/bbl_projects/22Q
subject=sub-109741
session=ses-22Q1

mkdir -p ${project}/data/freeqc/${subject}/${session}

SINGULARITYENV_SUBNAME=$subject
SINGULARITYENV_SESNAME=$session
SINGULARITYENV_SUBCOL=bblid

singularity run --writable-tmpfs --cleanenv \
	-B ${project}/data/freesurfer/${subject}/${session}:/input/data \
	-B ${project}/images/license.txt:/opt/freesurfer/license.txt \
	-B ${project}/data/freeqc/${subject}/${session}:/output \
	${project}/images/freeqc_0.0.12.sif
