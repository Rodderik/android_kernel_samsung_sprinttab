#!/sbin/sh
# custom_init functions

# Remount filesystems RW

/sbin/busybox mount -o remount,rw /dev/block/stl9 /system
/sbin/busybox mount -o remount,rw / /

# Install busybox
#/sbin/busybox --install -s /sbin
rm -rf /system/xbin/busybox
ln -s /sbin/busybox /system/xbin/busybox
rm -rf /res
sync

# Fix permissions in /sbin, just in case
chmod 755 /sbin/*

# Fix screwy ownerships
for blip in default.prop fota.rc init init.goldfish.rc init.rc lib lpm.rc modules recovery.rc ueventd.rc res sbin
do
	chown root.system /$blip
	chown root.system /$blip/*
done

chown root.system /lib/modules/*
chown root.system /res/images/*

# setup su
chown root.root /sbin/su
chmod 06755 /sbin/su
# establish root in common system directories for 3rd party applications
rm /system/bin/su
rm /system/xbin/su
rm /system/bin/jk-su
cp -f /sbin/su /system/bin/su
cp -f /sbin/su /system/xbin/su
chmod 06755 /system/bin/su
chmod 06755 /system/xbin/su
# remove su in problematic locations
rm -rf /bin/su

#Check and setup Superuser if missing
 if [ ! -f "/system/app/Superuser.apk" ] && [ ! -f "/data/app/Superuser.apk" ] && [[ ! -f "/data/app/com.noshufou.android.su"* ]]; then
 	busybox cp /sbin/Superuser.apk /system/app/Superuser.apk
 fi

# Enable init.d support
if [ -d /system/etc/init.d ]
then
	logwrapper busybox run-parts /system/etc/init.d
fi
sync

# fix busybox DNS while system is read-write
if [ ! -f "/system/etc/resolv.conf" ]; then
	echo "nameserver 8.8.8.8" > /system/etc/resolv.conf
	echo "nameserver 8.8.4.4" >> /system/etc/resolv.conf
fi 
sync

# Patch to attempt removal and prevention of DroidDream malware (Exploit should be fixed in GB)
if [ -f "/system/bin/profile" ]; then
	rm /system/bin/profile
fi
touch /system/bin/profile
chmod 644 /system/bin/profile

# remount read only and continue
mount -o remount,ro /dev/stl9 /system
mount -o remount,ro / /
