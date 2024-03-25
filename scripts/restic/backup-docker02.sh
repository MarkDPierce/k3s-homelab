#!/bin/bash

declare -a FOLDER_PATHS=("/home/homelab/privatelab/docker-compose/traefik/srv" "/home/homelab/privatelab/docker-compose/uptime-kuma/srv" "/home/homelab/privatelab/docker-compose/monitoring/srv")

# Restic documentation in relation to using CIFS
export GODEBUG=asyncpreemptoff=1
# Location of the backup desto
REPOSITORY="/backups"
# Path for logs
MY_RESTIC_LOGS_PATH="/home/homelab"

datestring() {
    date +%Y-%m-%d\ %H:%M:%S
}

# Create log file
START_TIMESTAMP=$(date +%s)
LOG_FILE="${MY_RESTIC_LOGS_PATH}/$(date +%Y-%m-%d-%H-%M-%S).log"
touch $LOG_FILE
echo "restic backup script started at $(datestring)" | tee -a $LOG_FILE
echo "REPOSITORY=${REPOSITORY}" | tee -a $LOG_FILE
echo "FOLDER_PATH=${FOLDER_PATH}" | tee -a $LOG_FILE
echo "HEALTHCHECKS_ID=${HEALTHCHECKS_ID}" | tee -a $LOG_FILE

# Main backup loop
for FOLDER_PATH in "${FOLDER_PATHS[@]}"
do

lockFile() {
    exec 99>"${LOCKFILE}"
    flock -n 99

    RC=$?
    if [ "$RC" != 0 ]; then
        echo "This restic ${REPOSITORY} backup of ${FOLDER_PATH} is already running. Exiting."
        exit
    fi
}

startHealthCheck() {
    if [ -n "${HEALTHCHECKS_ID}" ]; then
        echo "Sending start ping to healthchecks.io at $(datestring)"
        curl -m 1 -fsS --retry 5 https://hc-ping.com/${HEALTHCHECKS_ID}/start
        echo ""
    fi
}

stopHealthCheck() {
    if [ -n "${HEALTHCHECKS_ID}" ]; then
        echo "Sending stop ping to healthchecks.io at $(datestring)"
        curl -m 1 -fsS --retry 5 https://hc-ping.com/${HEALTHCHECKS_ID}
        echo ""
    fi
}

failHealthCheck() {
    if [ -n "${HEALTHCHECKS_ID}" ]; then
        echo "Sending fail ping to healthchecks.io at $(datestring)"
        curl -m 1 -fsS --retry 5 https://hc-ping.com/${HEALTHCHECKS_ID}/fail
        echo ""
    fi
}

# Backup Function
runBackup(){
    restic -r $REPOSITORY backup \
      --verbose \
      --password-file .restic \
      --exclude-if-present .resticignore \
    $FOLDER_PATH

    if [ $(echo $?) -eq 1 ]; then
        echo "Fatal error detected!"
        failHealthCheck | tee -a $LOG_FILE
        echo "Cleaning up lock file and exiting."
        rm -f ${LOCKFILE} | tee -a $LOG_FILE
        exit 1
    fi
}

# Prune Function
pruneOld() {
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

# Start helthcheck
startHealthCheck | tee -a $LOG_FILE

# Create lockfile
LOCKFILE="/tmp/my_restic_backup.lock"
lockFile | tee -a $LOG_FILE

# Run the backup
runBackup | tee -a $LOG_FILE

# Prune old backups
pruneOld | tee -a $LOG_FILE

# clean up lockfile
rm -f ${LOCKFILE} | tee -a $LOG_FILE

# Stop helthcheck
stopHealthCheck | tee -a $LOG_FILE

done

delta=$(date -d@$(($(date +%s) - $START_TIMESTAMP)) -u +%H:%M:%S)
echo "restic backup script for finished at $(datestring) in ${delta}" | tee -a $LOG_FILE
curl "https://gotify.mpierce.net/message?token=FFFFFFFFF" -F "title=Docker02 Backups Complete" -F "message=restic backup script for finished at $(datestring) in ${delta}" -F "priority=5"