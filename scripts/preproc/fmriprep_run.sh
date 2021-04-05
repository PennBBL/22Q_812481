#!/bin/bash

project=/project/bbl_projects/22Q
mkdir -p ${project}/scripts/jobscripts/fmriprep_jobscripts

SIF=${project}/images/fmriprep_20.2.1.sif

subjList=`ls ${project}/data/bids_directory/`

for subject in $subjList; do

	echo SUBJECT: ${subject}

	cat <<- EOS > ${project}/scripts/jobscripts/fmriprep_jobscripts/${subject}.sh
		#!/bin/bash
		
		singularity run --cleanenv \\
		-B ${project}/data/bids_directory:/bids \\
		-B ${project}/data/preproc:/out \\
		-B ${project}/images/license.txt:/license/txt \\
		-B ${project}/work:/work \\
		${SIF} \\
		/bids /out participant \\
		--participant-label ${subject} \\
		--work-dir /work \\
		--fs-license-file /license.txt \\
		--stop-on-first-crash \\
		--skip-bids-validation
		
		EOS
done

