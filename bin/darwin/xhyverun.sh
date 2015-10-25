#!/bin/bash

path=$(grealpath $1)

KERNEL=$path/$(ls $path | grep  "vmlinuz-")
INITRD=$path/$(ls $path | grep  "initramfs-")
HDD=$path/$(ls $path | grep  "hdd.img")
CMDLINE_FILE=$path/$(ls $path | grep  "cmdline")
CMDLINE=$(cat $CMDLINE_FILE)

if [[ ! -f $path/.uuid ]]; then
  uuidgen > $path/.uuid
fi
UUID=$(cat $path/.uuid)
if [[ ! -f $path/.mac_address ]]; then
  sudo uuid2mac $UUID > $path/.mac_address
fi

#ACPI="-A"
MEM="-m 2G"
#SMP="-c 2"
NET="-s 2:0,virtio-net"
IMG_HDD="-s 4,virtio-blk,$HDD"
PCI_DEV="-s 0:0,hostbridge -s 31,lpc"
LPC_DEV="-l com1,stdio"
UUID="-U $UUID"

pushd $path
sudo xhyve $ACPI $MEM $SMP $PCI_DEV $LPC_DEV $NET $IMG_CD $IMG_HDD $UUID -f kexec,$KERNEL,$INITRD,"$CMDLINE"
popd

