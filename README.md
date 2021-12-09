# Automate ComputeStacks Controller Backups

This is a cron job that will automatically backup the controller database, retain a fixed number of backups, and optionally sync using rclone. 

## Installation

### Install files and dependencies

This script will install our two scripts, and rclone.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ComputeStacks/controller-backups/main/install.sh)"
```

### Configure rclone

Before proceeding, decide which storage system you will use: https://rclone.org/overview/

Use `rclone config` to setup and configure your storage system. Take note of the name you give your storage account.

### Configure backups

Add the following to `/etc/default/computestacks`, and make any necessary changes

```bash
LOCAL_BACKUPS_TO_KEEP=7
RCLONE_PROFILE= # This is the name you set when using `rclone config`.
RCLONE_REMOTE_PATH= # bucket name. May also include path in bucket, example: mybucket/somepath
```

### Setup cron

Use `crontab -e`

#### Examples

```
# Run everyday at 03:30
30 3 * * * /usr/local/bin/controller-backup >> /var/log/rclone/controller-backup.log 2>&1
```

```
# Run every 12 hours
0 */12 * * * /usr/local/bin/controller-backup >> /var/log/rclone/controller-backup.log 2>&1
```

