#!/bin/bash

export LOGS_DIR=/home/kzoner/logs/22Q/freeqc

project=/project/bbl_projects/22Q

mkdir -p ${project}/scripts/jobscripts/freeqc_jobscripts

imgList=`ls ${project}/data/bids_directory/*/*/anat/*.nii.gz`

for img in $imgList; do

        subject=`basename $img | cut -d _ -f 1`
        session=`basename $img | cut -d _ -f 2`
	
	echo SUBJECT: $subject SESSION: $session
	mkdir -p ${project}/data/freeqc/${subject}/${session}

	jobscript=${project}/scripts/jobscripts/freeqc_jobscripts/${subject}_${session}.sh
	
	cat <<- EOS > ${jobscript}
		#!/bin/bash
		
		SINGULARITYENV_SUBNAME=${subject} \\
        	SINGULARITYENV_SESNAME=${session} \\
        	SINGULARITYENV_SUBCOL=bblid \\
        	singularity run --writable-tmpfs --cleanenv \\
        	-B ${project}/data/freesurfer-7.1.1/${subject}/${session}:/input/data \\
        	-B ${project}/images/license.txt:/opt/freesurfer/license.txt \\
        	-B ${project}/data/freeqc/${subject}/${session}:/output \\
        	${project}/images/freeqc_0.0.13.sif

	EOS

	chmod +x ${jobscript}

	bsub -e $LOGS_DIR/${subject}_${session}.e -o $LOGS_DIR/${subject}_${session}.o -q bbl_normal -m linc1 ${jobscript}
done


