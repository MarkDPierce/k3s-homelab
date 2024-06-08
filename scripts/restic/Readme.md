# Restic

## Backups

Creating out mountpoint for the backups directory on the nas

```shell
mkdir /backups
```

Modify fstab to add the backup path to our NAS.

```shell
vim /etc/fstab
```

And Add to fstab. These will rquire `smbclient cifs-utils` to be install through apt.

```txt
//192.168.178.101/timemachine/docker01 /backups cifs credentials=/home/homelab/.cifs,uid=root,noperm,rw 0 0
```

Creating the credentials file

```shell
vim /home/homelab/.cifs
```

Then you can add.

```
username=john
password=123
```

Set the correct permissions.

```shell
chmod 600 /home/homelab/.cifs
```

Finaly reload the daemons due to changing fstab

```shell
systemctl daemon-reload
```


## Restores

Mount the location of the backup source.
