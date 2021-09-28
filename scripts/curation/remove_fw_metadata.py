##
##
##

import flywheel
import logging
import sys

# Set up logging
logging.basicConfig(
    stream=sys.stdout,
    level=logging.INFO,
    format='%(levelname)s: %(message)s')
logger = logging.getLogger('fw_remove_metadata')

# Specify project (required)
project_label = "22Q_812481"

# Specify sessions (optional)
session_labels = None
#session_labels = ["008120", "008144"]

# Which file types to change metadata
allowed_ftypes = ["nifti"]

# Specify list of fields to delete
fields_for_removal = [
    "AcquisitionDateTime",
    "AcqusitionTime",
    "PatientSex",
    "SeriesInstanceUID",
    "DeviceSerialNumber",
    "AcquisitionTime",
    "ReferringPhysicianName",
    "StationName",
    "InstitutionAddress",
    "InstitutionName",
    "InstitutionalDepartmentName",
    ###### ASL specific: ######
    "AcquisitionDuration",
    "ArterialLabelingType",
    "AverageB1LabelingPulses",
    "AverageLabelingGradient",
    "BolusCutOffDelayTime",
    "BolusCutOffFlag",
    "BolusCutOffTechnique",
    "BolusCutOffTimingSequence",
    "LabelingOrientation",
    "LookLocker",
    "M0",
    "PASLType",
    "PulseDuration",
    "PulseSequenceDetails"
]


def remove_metadata(client):
    '''
    Remove metadata fields from nifti files across the project 
    based on hard-coded list, fields_for_removal. 
    '''

    # Get project object
    project = client.projects.find_first('label="{}"'.format(project_label))
    assert project, "Project not found!"
    logger.info('Found project: %s (%s)', project['label'], project.id)

    # Get all sessions in project
    sessions = project.sessions()

    # Filter by optionally-specified session label list
    if session_labels:
        sessions = [s for s in sessions if s.label in session_labels]

    assert sessions, "No sessions found!"
    logger.info("The following metadata fields will be removed: \n\t{}".format(
        "\n\t".join(sorted(fields_for_removal))))
    logger.info(f"Metadata fields will be removed from {len(sessions)} sessions.\n")

    # Get acquisitions in each session
    i = 0
    for sess in sessions:
        i += 1
        #sess = sess.reload()
        acqs = sess.acquisitions()
        logger.info(f"Processing session: {sess.label} ({i}/{len(sessions)})\n")

        # Get files in each acquisition
        for acq in acqs:
            acq = acq.reload()  # Can't load custom metadata without this line!!!
            files = [f for f in acq.files if f.type in allowed_ftypes]

            # Delete info from each file
            for f in files:
                f.delete_info(fields_for_removal)
                #print("Removed fields from:\t{}".format(f.name))
                logger.info(f"Removing metadata from {f.name}")
        print()

def main():
    # Get client
    fw = flywheel.Client()
    assert fw, "Your Flywheel CLI credentials aren't set!"

    # Remove specified list of metadata fields from project / specified sessions
    remove_metadata(fw)
    logger.info("Done!")


if __name__ == '__main__':
    main()