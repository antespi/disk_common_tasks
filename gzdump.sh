#!/bin/bash

if [ ! $# -eq 2 ]; then echo "Usage: $0 <device> <file.gz>"; exit 1; fi

DEVICE="$1"
FILE="$2"

if [ ! -b "$DEVICE" ]; then echo "'$DEVICE' does not exists or not a block special file"; exit 2; fi
if ! /bin/touch "$FILE"; then echo "'$FILE' can not be created"; exit 3; fi

/bin/dd if="$DEVICE" conv=sync,noerror bs=64K | /bin/gzip -c  > "$FILE"



