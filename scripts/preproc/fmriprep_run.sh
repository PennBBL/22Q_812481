#!/bin/bash

project=/project/bbl_projects/22Q
LOGS=/home/kzoner/logs/22Q/fmriprep

mkdir -p ${project}/scripts/jobscripts/fmriprep_jobscripts

SIF=${project}/images/fmriprep_20.2.1.sif

subjList=`ls -d ${project}/data/bids_directory/sub-* | cut -d / -f 7`

for subject in $subjList; do

	echo SUBJECT: ${subject}
	jobscript=${project}/scripts/jobscripts/fmriprep_jobscripts/${subject}.sh

	cat <<- EOS > ${jobscript}
		#!/bin/bash
		
		SINGULARITYENV_SURFER_FRONTDOOR=1 \\
		singularity run --cleanenv \\
		-B ${project}/data/bids_directory:/bids \\
		-B ${project}/data/preproc:/out \\
		-B ${project}/images/license.txt:/license.txt \\
		-B ${project}/work:/work \\
		-B ${SINGULARITY_TMPDIR}:${SINGULARITYENV_TMPDIR} \\
		${SIF} \\
		/bids /out participant \\
		--participant-label ${subject} \\
		--work-dir /work \\
		--fs-license-file /license.txt \\
		--stop-on-first-crash \\
		--skip-bids-validation
		
		EOS

	chmod +x ${jobscript}
	bsub -e ${LOGS}/${subject}.e -o ${LOGS}/${subject}.o ${jobscript}
	break
done

