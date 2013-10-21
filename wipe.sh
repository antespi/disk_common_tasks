#!/bin/bash

if [ ! $# -eq 2 ]; then echo "Usage: $0 <device> <mount_point>"; exit 1; fi

DEVICE="$1"
MOUNT_POINT="$2"

if [ ! -b "$DEVICE" ]; then echo "'$DEVICE' does not exists or not a block special file"; exit 2; fi
if [ ! -d "$MOUNT_POINT" ]; then echo "'$MOUNT_POINT' does not exists or not a directory"; exit 3; fi

/bin/echo "---- Erasing free data ------------------------------------"
/bin/echo "- Checking partition"
/sbin/fsck -n "$DEVICE"

/bin/echo "- Disabling journal"
/sbin/tune2fs -O ^has_journal "$DEVICE"

/bin/echo "- Checking partition, again"
/sbin/e2fsck -f "$DEVICE"

/bin/echo "- Filling free space with zeros"
/bin/mount "$DEVICE" "$MOUNT_POINT"
/bin/cat /dev/zero > "$MOUNT_POINT/filler"
/bin/rm "$MOUNT_POINT/filler"
/bin/sync
/bin/umount "$DEVICE"

/bin/echo "- Enabling journal"
/sbin/tune2fs -j "$DEVICE"

/bin/echo "- Checking partition, finally"
/sbin/fsck -n "$DEVICE"
/bin/echo "---- OK -----"


