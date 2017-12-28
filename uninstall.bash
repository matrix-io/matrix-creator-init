#!/bin/bash

echo "Disable firmware loading at startup"
systemctl disable matrix-creator-firmware

rm -rf /usr/share/matrixlabs/matrixio-devices

rm -rf /lib/systemd/system/matrixio-devices-firmware.service
rm -rf /usr/bin/matrix-creator-reset-jtag
rm -rf /etc/modules-load.d/creator-mics.conf
rm -rf /etc/modules-load.d/raspicam.conf
rm -rf /etc/asound.conf

cp /boot/config.txt.bk /boot/config.txt

echo "Please restart your Raspberry Pi after installation"
