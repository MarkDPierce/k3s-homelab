#!/bin/bash

# Need to document this
# https://gist.github.com/paolobasso99/88a7f73efedc08b2fd006b1002e9a379
# https://www.monotux.tech/posts/2023/08/restic-backup-script/
# Mounting CIFS https://help.ubuntu.com/community/MountCifsFstab
# Mounting CIFS https://forum.openmediavault.org/index.php?thread/23489-ubunutu-18-04-how-to-automount-a-cifs/&postID=178599&highlight=fstab#post178599
# Restic local https://restic.readthedocs.io/en/latest/030_preparing_a_new_repo.html#local

# Restic documentation in relation to using CIFS
export GODEBUG=asyncpreemptoff=1

declare -a FOLDER_PATHS=(
    "/home/homelab/privatelab"
)

# Location of the backup desto
REPOSITORY="/backups"

# Standardized date/time
datestring() {
    date +%Y-%m-%d\ %H:%M:%S
}

# Create log file contents
# Define log Path
MY_RESTIC_LOGS_PATH="/home/homelab"
cd $MY_RESTIC_LOGS_PATH

# Define LOG_FILE
START_TIMESTAMP=$(date +%s)
LOG_FILE="${MY_RESTIC_LOGS_PATH}/$(date +%Y-%m-%d-%H-%M-%S).log"
touch $LOG_FILE
echo "restic backup script started at $(datestring)" | tee -a $LOG_FILE
echo "REPOSITORY=${REPOSITORY}" | tee -a $LOG_FILE
echo "HEALTHCHECKS_ID=${HEALTHCHECKS_ID}" | tee -a $LOG_FILE

# Send completion message
send_message() {
    # Send curl message
    curl "https://gotify.mpierce.net/message?token=Az_x0izl7Baj6yW" -F "title=$HOSTNAME Backups Complete" -F "message=restic backup script for finished at $(datestring) in ${delta}" -F "priority=5"
}

run_backup() {
    local REPOSITORY=$1
    local FOLDER_PATH=$2
    # Backup script contents
    restic -r $REPOSITORY backup \
        --verbose=2 \
        --no-scan \
        --read-concurrency \
        --password-file .restic \
        $FOLDER_PATH
}   

prune_old_backup() {
    local REPOSITORY=$1
    local FOLDER_PATH=$2
    echo "Prune old backups at $(datestring)"
    restic -r $REPOSITORY forget \
        --verbose \
        --password-file .restic \
        --prune --keep-last 10 \
        --keep-hourly 1 \
        --keep-daily 10 \
        --keep-weekly 5 \
        --keep-monthly 14 \
        --keep-yearly 100

    echo "Check repository at $(datestring)"
    restic -r $REPOSITORY check \
        --verbose \
        --password-file .restic
}

prune_logs() {
    echo "Pruning old Logs"
    sorted_files=($(ls -t | grep .log))

    # Get the total number of log files
    total_files=${#sorted_files[@]}

    # Specify the number of files to keep (e.g., keep the 10 most recent files)
    files_to_keep=10

    # Loop through the sorted files starting from the files_to_keep index
    for ((i=$files_to_keep; i<$total_files; i++)); do
        # Delete files beyond the 10th file
        rm -rf "${sorted_files[$i]}" --verbose
    done
}

start_healthcheck() {
    if [ -n "${HEALTHCHECKS_ID}" ]; then
        echo "Sending start ping to healthchecks.io at $(datestring)"
        curl -m 1 -fsS --retry 5 https://hc-ping.com/${HEALTHCHECKS_ID}/start
        echo ""
    fi
}

stop_healthcheck() {
    if [ -n "${HEALTHCHECKS_ID}" ]; then
        echo "Sending stop ping to healthchecks.io at $(datestring)"
        curl -m 1 -fsS --retry 5 https://hc-ping.com/${HEALTHCHECKS_ID}
        echo ""
    fi
}

lock_file() {
    exec 99>"${LOCKFILE}"
    flock -n 99

    RC=$?
    if [ "$RC" != 0 ]; then
        echo "This restic ${REPOSITORY} backup of ${FOLDER_PATH} is already running. Exiting."
        exit
    fi
}

# Iterate  over FOLDER_PATHS
# execute run_backup() for each folder path
for FOLDER_PATH in "${FOLDER_PATHS[@]}"; do
    echo "FOLDER_PATH=${FOLDER_PATH}" | tee -a $LOG_FILE

    # Start Healthcheck
    #start_healthcheck | tee -a $LOG_FILE

    # Create Lockfile
    LOCKFILE=/tmp/my_restic_backup.lock
    lock_file | tee -a $LOG_FILE

    # Run the Backup
    run_backup $REPOSITORY $FOLDER_PATH | tee -a $LOG_FILE

    # Prune old Backups
    prune_old_backup $REPOSITORY "$FOLDER_PATH" | tee -a $LOG_FILE

    # Prune old backup Logs
    prune_logs | tee -a $LOG_FILE

    # Clean up lockfile
    rm -f ${LOCKFILE} | tee -a $LOG_FILE

    # Stop Healthcheck
    #stop_healthcheck | tee -a $LOG_FILE
done

delta=$(date -d@$(($(date +%s) - $START_TIMESTAMP)) -u +%H:%M:%S)

echo "restic backup script for finished at $(datestring) in ${delta}" | tee -a $LOG_FILE
# Send Message
send_message