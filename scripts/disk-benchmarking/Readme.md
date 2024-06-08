# Disk Benchmarking

I was watching Jeff Geerling and got the idea to do a highly similar setup he has for benchmarking disk IO. I took his script as a bit of inspiration and attempted to make an all in 1 style run script to benchmark IO and disks.

## FIO
[https://github.com/axboe/fio]()

FIO is used to check file level IO. It needs to be pointed at a directory you are attempting to test. This directory could be a single partition on a single drive, or a raid volume across multiple drives. The goal of the software is to test I/O. It does this by creating a file of defined size and writing/reading to it based on a ton of possible values.

FIO is usually available through package managers so there is a check in the script to check for it and install it if required.

```
apt install fio
```

### FIO Examples

[https://github.com/axboe/fio/tree/master/examples]

The repo does a good job at providing a lot of examples in the form of configuration files. You can also spawn multiple different job types with these conf files.

I am mostly just using the SSD benchmark provided. 

## IOZone
[https://www.iozone.org/]()

I do my best to download and set this tool up in the script. You do need to be mindful of the make command as it requires a specific architechture type.

IOZone usually also requires `apt install gcc` because we build from source.

## Running The Script

Before you can run the script you will have to adjust a few things. At the bottom adjust any of the tests that are ran. These are unique to each machine.

Some useful commands when navigating volumes.

```shell
fdisk -l
df -h
```

Create the script on your remote machine and make it executable.

```shell
touch disk-management.sh
vim disk-management.sh # Copy over script content
chmod +x disk-management.sh
```

You should be ready to run the script. **This script requires root or sudo**

```shell
sudo ./disk-management.sh
```

## Viewing the Results

If you did not modify the `$OUTPUT` variable in the script. All your results should have ended up in `/iozone`.