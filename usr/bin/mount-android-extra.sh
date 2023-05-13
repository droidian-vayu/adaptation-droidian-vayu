#!/bin/sh
mount -o loop,ro,noatime,nosuid,nodev,discard -t ext4 /var/lib/lxc/android/firmware/metadata.img /android/metadata
mount -o loop,ro,shortname=lower,uid=1000,gid=1000,dmask=227,fmask=337 -t vfat /var/lib/lxc/android/firmware/modem.img /android/vendor/firmware_mnt
mount -o loop,ro,nosuid,nodev,barrier=1 -t ext4 /var/lib/lxc/android/firmware/dsp.img /android/vendor/dsp
mount -o loop,ro,shortname=lower,uid=1002,gid=3002,dmask=227,fmask=337 -t vfat /var/lib/lxc/android/firmware/bluetooth.img /android/vendor/bt_firmware
