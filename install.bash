#!/bin/bash

mkdir /usr/share/admobilize/matrixio-devices
cp -avr blob cfg sam3-program.bash fpga-program.bash em358-program.bash creator-init.bash radio-init.bash firmware_info mcu_firmware.version admobilize_edit_setting.py admobilize_remove_console.py 

mkdir /usr/share/admobilize/matrixio-devices/config
cp -avr boot_modifications.txt /usr/share/admobilize/matrixio-devices/config

cp -avr matrix-creator-firmware.service /lib/systemd/system
cp -avr matrix-creator-reset-jtag /usr/bin
cp -avr creator-mics.conf /etc/modules-load.d
cp -avr raspicam.conf /etc/modules-load.d
cp -avr asound.conf /etc/

echo "Enabling firmware loading at startup"
systemctl enable matrix-creator-firmware

# This didn't work due to an unresolved shared library.
# Asking users to reboot after installation.
# echo "Loading firmware..."
# service matrix-creator-firmware start

echo "Enabling SPI"
cp /boot/config.txt /boot/config.txt.bk && /usr/share/admobilize/matrixio-devices/admobilize_edit_setting.py /boot/config.txt.bk /usr/share/admobilize/matrixio-devices/config/boot_modifications.txt > /boot/config.txt

echo "Disable UART console"
/usr/share/admobilize/matrixio-devices/admobilize_remove_console.py

echo "Please restart your Raspberry Pi after installation"
