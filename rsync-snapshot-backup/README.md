
# rsync Remote Backup

Automatically create HomeAssistant snapshots and backup to remote server using `rsync`.


## Table of Contents

* [Configuration](#configuration)
* [Example](#example)

## Configuration

|Parameter|Required|Description|
|---------|--------|-----------|
|`rsync_host`|Yes|The hostname/url to the rsync server.|
|`rsync_user`|Yes|Username to use for `rsync`.|
|`rsync_password`|Yes|Password to use for `rsync`.|
|`remote_directory`|Yes|The directory to put the backups on the remote server.<br />For example, on a Synology NAS, this would be the name of the Share.|
|`snapshot_password`|No|If set, the snapshot will generate with a password.|
|`keep_local_backup`|No|Control how many local backups you want to preserve.<br />- Default (`""`) is to keep no local backups created from this addon.<br />- If `all` then all local backups will be preserved.<br />- A positive integer will determine how many of the latest backups will be preserved. Note this will delete other local backups created outside this addon.|
|`SSH_port`|Yes|SSH port used by `rsync` to send file to.|


## Example

Example of a configuration that would do daily backups at 4 AM.

_configuration.yaml_
```yaml
automations:
  - alias: Daily Backup at 4 AM
  trigger:
    platform: time
    at: '4:00:00'
  action:
  - service: hassio.addon_start
    data:
      addon: ce20243c_rsync_remote_backup
```

_Add-on configuration_:
```yaml
rsync_host: 192.168.1.2
rsync_user: hass
rsync_password: 'some_password'
remote_directory: 'homeassistant'
snapshot_password: ''
keep_local_backup: 2
SSH_port: 22
```

**Note**: _This is just an example, don't copy and past it! Create your own!_
