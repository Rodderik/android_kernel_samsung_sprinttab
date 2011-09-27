#/bin/bash +x
# temporary build script to save me some typing...I'll do a proper one later

WDIR="/home/rodderik/android_kernel_samsung_sprinttab"
CC="/usr/local/toolchain/arm-2009q3/bin/arm-none-linux-gnueabi-"
DEFCONFIG="p1_defconfig"
OUTNAME="p100kernel"

rm $WDIR/p100kernel.tar.md5
rm $WDIR/zImage
rm $WDIR/recovery.bin

# Temp work-around: .git folder causes kernel not to boot...we will revisit this soon
mv $WDIR/.git $WDIR/RENAME_ME.git

cd $WDIR/Kernel
make mrproper
make ARCH=arm $DEFCONFIG
make -j4 ARCH=arm CROSS_COMPILE=$CC

# Temp work-around: .git folder causes kernel not to boot...we will revisit this soon
mv $WDIR/RENAME_ME.git $WDIR/.git

# Make Odin flashable .tar.md5 for now
cd $WDIR
cp $WDIR/Kernel/arch/arm/boot/zImage $WDIR/zImage
cp $WDIR/Kernel/arch/arm/boot/zImage $WDIR/recovery.bin
tar -H ustar -c zImage recovery.bin > $OUTNAME.tar
md5sum -t $OUTNAME.tar >> $OUTNAME.tar
mv $OUTNAME.tar $OUTNAME.tar.md5
