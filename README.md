
# rsync Remote Backup for HomeAssistant

[![GitHub license][license-shield]](LICENSE.md)

Automatically create HomeAssistant snapshots and backup to remote server using `rsync`.


## Table of Contents

* [About](#about)
* [Installation](#installation)

## About

When the add-on is started the following happens:
1. Snapshot are being created locally with a timestamp name, e.g.
*Automatic Backup 2018-03-04 04:00*.
1. The snapshot are copied to the specified remote location using `rsync`.
1. The local backups are removed.

_Note_ the filenames of the backup are given by their assigned slug.

This was tested using `rsync` on a Synology NAS.

## Installation

1. Add the addon repository to your HomeAssistant instance: `https://github.com/Sarabveer/rsync-snapshot-backup`.
1. Install the rsync Remote Backup addon.
1. Configure the add-on with your rsync credentials and desired output directory
(see configuration below).

## Configuration

Go to the addon [README](./rsync-snapshot-backup/README.md) for configuration options. 