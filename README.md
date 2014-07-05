#raspberryos

A repo to capture the output of going through the tutorials found here: http://www.cl.cam.ac.uk/projects/raspberrypi/tutorials/os/

## Build Notes

Following a suggestion in this README https://github.com/dwelch67/raspberrypi/blob/master/README I got the two files `bootcode.bin` and `start.elf` from the firmware directory at http://github.com/raspberrypi. Doing some allows you to load onto the raspberry pi without having an OS already installed on it.

After you have created a `kernel.img` file and have downloaded the two files above, the process to get it on the raspberry on Mac OS is as follows:

* Plug SD card into your computer and wipe it by creating a single FAT32 partition called whatever you like (using Disk Utilites)
* Copy your three files kernel.img, bootloader.bin, and start.elf onto the partition
* Unmount the partition (from Disk Utilities)
* Eject the SD card from your computer
* Plug the SD card into your raspberry pi BEFORE the power
* Power on your raspberry pi and your kernel should load immediately

