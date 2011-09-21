#!/sbin/sh
# custom recovery functions

# Remount filesystem rw
/sbin/busybox mount -o remount,rw / /

# Install extra recovery files to /sbin
/sbin/busybox ls /res/sbin | while read line
do
  /sbin/busybox mv -f /res/sbin/$line /sbin/$line
done
rmdir /res/sbin

# Fix permissions in /sbin, just in case
/sbin/busybox chmod 755 /sbin/*

# Fix screwy ownerships
for blip in conf default.prop fota.rc init init.goldfish.rc init.rc lib lpm.rc modules recovery.rc ueventd.rc res sbin
do
  chown root.system /$blip
  chown root.system /$blip/*
done

chown root.system /lib/modules/*
chown root.system /res/images/*

# Place recovery.fstab and start CWM
/sbin/busybox mkdir /etc
/sbin/busybox cat /res/etc/recovery.fstab > /etc/recovery.fstab
sync
/sbin/recovery

