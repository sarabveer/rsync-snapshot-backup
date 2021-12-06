#!/bin/bash
set -e

CONFIG_PATH=/data/options.json

# parse inputs from options
RSYNC_HOST=$(jq --raw-output ".rsync_host" $CONFIG_PATH)
RSYNC_USER=$(jq --raw-output ".rsync_user" $CONFIG_PATH)
RSYNC_PASSWORD=$(jq --raw-output ".rsync_password" $CONFIG_PATH)
REMOTE_DIRECTORY=$(jq --raw-output ".remote_directory" $CONFIG_PATH)
SNAPSHOT_PASSWORD=$(jq --raw-output '.snapshot_password' $CONFIG_PATH)
KEEP_LOCAL_BACKUP=$(jq --raw-output '.keep_local_backup' $CONFIG_PATH)
SSH_PORT=$(jq --raw-output '.SSH_port' $CONFIG_PATH)

export SSHPASS=${RSYNC_PASSWORD}

echo "[INFO] Starting rsync Snapshot Backup..."

function create-local-backup {
    name="Automated Backup $(date +'%Y-%m-%d %H:%M')"
	if [[ -z $SNAPSHOT_PASSWORD  ]]; then
		echo "[INFO] Creating local backup: \"${name}\""
		slug=$(ha backups new --raw-json --name="${name}" | jq --raw-output '.data.slug')
	else
		echo "[INFO] Creating local backup with password: \"${name}\""
		slug=$(ha backups new --raw-json --name="${name}" --password="${SNAPSHOT_PASSWORD}" | jq --raw-output '.data.slug')
		backup_name=$(ha backups new --raw-json --name="${name}" --password="${SNAPSHOT_PASSWORD}" | jq --raw-output '.data.name')
	fi
    echo "[INFO] Backup created: ${slug}"
}

function copy-backup-to-remote {
	rsyncurl="$RSYNC_USER@$RSYNC_HOST:$REMOTE_DIRECTORY"
	echo "[INFO] Copying ${backup_name} to ${REMOTE_DIRECTORY} on ${RSYNC_HOST} using rsync. Slug is ${slug}"
	sshpass -e rsync -av -e "ssh -p ${SSH_PORT} -o StrictHostKeyChecking=no" /backup/ $rsyncurl --ignore-existing
	
}

function delete-local-backup {
    ha backups reload
    if [[ ${KEEP_LOCAL_BACKUP} == "all" ]]; then
        :
    elif [[ -z ${KEEP_LOCAL_BACKUP} ]]; then
        echo "[INFO] Deleting local backup: ${slug}"
        ha backups remove "${slug}"
    else
        last_date_to_keep=$(ha backups list --raw-json | jq .data.backups[].date | sort -r | \
            head -n "${KEEP_LOCAL_BACKUP}" | tail -n 1 | xargs date -D "%Y-%m-%dT%T" +%s --date )

        ha backups list --raw-json | jq -c .data.backups[] | while read backup; do
            if [[ $(echo ${backup} | jq .date | xargs date -D "%Y-%m-%dT%T" +%s --date ) -lt ${last_date_to_keep} ]]; then
                echo "[INFO] Deleting local backup: $(echo ${backup} | jq -r .slug)"
                ha backups remove "$(echo ${backup} | jq -r .slug)"
            fi
        done
    fi
}

create-local-backup
copy-backup-to-remote
delete-local-backup

echo "[INFO] Backup process done!"
exit 0
