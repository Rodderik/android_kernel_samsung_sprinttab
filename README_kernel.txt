HOW TO BUILD KERNEL 2.6.35 FOR SPH-P100

1. How to Build
	- get Toolchain
	Visit http://www.codesourcery.com/, download and install Sourcery G++ Lite 2009q3-68 toolchain for ARM EABI.
        Extract kernel source and move into the top directory.
	$ toolchain\arm-eabi-4.4.0
	$ cd Kernel/
	$ make clean
	$ make p1_defconfig
	$ make
	
2. Output files
	- Kernel : Kernel/arch/arm/boot/zImage
	- module : Kernel/drivers/*/*.ko
	
3. How to make .tar binary for downloading into target.
	- change current directory to Kernel/arch/arm/boot
	- type following command
	$ tar cvf SPH-P100_Kernel_Gingerbread.tar zImage
