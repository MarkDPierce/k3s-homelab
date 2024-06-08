#!/bin/bash

if [ $EUID -ne 0 ] && ! sudo -n true 2>/dev/null; then
    echo "This script must be run with root or sudo."
    exit 1
fi

# Install dependencies.
if [ ! `which fio` ]; then
  printf "Installing fio...\n"
  apt-get install -y fio
  printf "Install complete!\n\n"
fi
if [ ! `which curl` ]; then
  printf "Installing curl...\n"
  apt-get install -y curl
  printf "Install complete!\n\n"
fi
if [ ! `which make` ]; then
  printf "Installing build tools...\n"
  apt-get install -y build-essential
  printf "Install complete!\n\n"
fi

# Variables.
USER_HOME_PATH=$(getent passwd $SUDO_USER | cut -d: -f6)
#USER_HOME_PATH=/root/disk-management
IOZONE_INSTALL_PATH=$USER_HOME_PATH
IOZONE_VERSION=iozone3_506

debug(){
    printf "##### iozone path var#####\n"
    printf "$IOZONE_INSTALL_PATH/$IOZONE_VERSION/src/current/iozone"
}
debug

# Download and build iozone.
if [ ! -f "$IOZONE_INSTALL_PATH/$IOZONE_VERSION/src/current/iozone" ]; then
  printf "Installing iozone...\n"
  curl "http://www.iozone.org/src/current/$IOZONE_VERSION.tar" | tar -x
  cd $IOZONE_VERSION/src/current
  #TODO: Build logic for this.
  #make --quiet linux-arm
  make --quiet linux-AMD64
  printf "Install complete!\n\n"
else
  cd $IOZONE_VERSION/src/current
fi

create_fio_test_file() {
    cat <<EOF >ssd-test.fio
[global]
bs=4k
ioengine=libaio
iodepth=4
size=10g
direct=1
runtime=60
filename=ssd.test.file

[seq-read]
rw=read
stonewall

[rand-read]
rw=randread
stonewall

[seq-write]
rw=write
stonewall

[rand-write]
rw=randwrite
stonewall
EOF
}

check_output_dir() {
    if [ $# -ne 1 ]; then
        echo "Usage: check_output_dir <directory>"
        return 1
    fi
    local OUTPUT=$1

    if [[ -d "$OUTPUT" ]]; then
        echo "Directory exists moving on."
    else
        mkdir $OUTPUT
    fi
}

# Represents a custom FIO test that doesnt use a config file
run_fio_test() {
    # Example usage:
    # run_fio_test <TEST_DIR> <OUTPUT>
    #    TEST_DIR: The target of the IO Test. Can be 1 pool on 1 disk. Or 1 pool on multiple diskss.
    #    OUTPUT: Save file directory and name ex. /home/user01/fio/test-result.txt

    if [ $# -ne 2 ]; then
        echo "Usage: run_fio_test <TEST_DIR> <OUTPUT>"
        return 1
    fi

    local TEST_DIR=$1
    local OUTPUT=$2
    # This file is used for read/write purposes and should be removed after testing, otherwise it takes up space.
    local FILENAME=volume.test.file

    # Navigate to the specified directory
    cd "$TEST_DIR" || return 1

    # Run fio test
    fio --name TEST \
        --eta-newline=5s \
        --filename="$FILENAME" \
        --rw=rw \
        --size=50g \
        --io_size=1500g \
        --blocksize=128k \
        --iodepth=16 \
        --direct=1 \
        --numjobs=16 \
        --runtime=120 \
        --group_reporting \
        --output="$OUTPUT"

    # Remove temporary file
    rm "$FILENAME"
    printf "\n"
}

# A FIO test using a config file created via create_fio_test_file()
run_fio_file_test() {
    # Example usage:
    # run_fio_file_test <TEST_DIR> <OUTPUT>
    #    TEST_DIR: The target of the IO Test. Can be 1 pool on 1 disk. Or 1 pool on multiple diskss.
    #    OUTPUT: Save file directory and name ex. /home/user01/fio/test-result.txt

    if [ $# -ne 2 ]; then
        echo "Usage: run_fio_file_test <TEST_DIR> <OUTPUT>"
        return 1
    fi

    # Tests the Directory which can consist of multiple disks
    local TEST_DIR=$1
    local OUTPUT=$2

    # Navigate to the specified directory
    cd "$TEST_DIR" || return 1

    # Create our FIO Test file
    create_fio_test_file

    # Run fio test
    fio ssd-test.fio \
        --output $OUTPUT \
        --directory $TEST_DIR

    # Remove temporary file, this is defined in create_fio_test_file()
    rm "ssd.test.file"
    printf "\n"
}

run_iozone_1k_rand () {
    if [ $# -ne 2 ]; then
        echo "Usage: run_iozone_1k_rand <directory> <output>"
        return 1
    fi

    local directory=$1
    local output=$2
    
    printf "Running iozone 1024K random read and write tests...\n"
    ./iozone \
        -e \
        -I \
        -a \
        -s 100M \
        -r 1024k \
        -i 0 \
        -i 2 \
        -f $directory > $output
    printf "\n"
}

run_iozone_4k_rand () {
    if [ $# -ne 2 ]; then
        echo "Usage: run_iozone_4k_rand <directory> <output> $<filname>"
        return 1
    fi

    local directory=$1
    local output=$2

    printf "Running iozone 4K random read and write tests...\n"
    ./iozone \
        -e \
        -I \
        -a \
        -s 100M \
        -r 4k \
        -i 0 \
        -i 2 \
        -f $directory > $output
    printf "\n" 
}

# Where we dump our test results
OUTPUT=/iozone
check_output_dir $OUTPUT

# FIO tests run within the directory they are targeting.
# iozone tests should run first due to this directory change.
run_iozone_1k_rand /dev/mapper/cachedev_0 "$OUTPUT/iozone-1k-volume1.txt"
run_iozone_4k_rand /dev/mapper/cachedev_0 "$OUTPUT/iozone-4k-volume1.txt"

run_iozone_1k_rand /dev/usb1p1 "$OUTPUT/iozone-1k-usbshare.txt"
run_iozone_4k_rand /dev/usb1p1 "$OUTPUT/iozone-4k-usbshare.txt"

#run_fio_test / "$OUTPUT/dev-sda3.txt"
run_fio_file_test /volume1 "$OUTPUT/volume1.txt"
run_fio_file_test /volumeUSB1/usbshare "$OUTPUT/usbshare.txt"
