#!/bin/bash

cd /usr/share/admobilize/matrix-creator

function try_program() {
  echo 18 > /sys/class/gpio/export 2>/dev/null
  echo out > /sys/class/gpio/gpio18/direction
  echo 1 > /sys/class/gpio/gpio18/value
  echo 0 > /sys/class/gpio/gpio18/value
  echo 1 > /sys/class/gpio/gpio18/value
  sleep 0.1
  openocd -f cfg/sam3s.cfg
}


count=0
while [  $count -lt 10 ]; do
  try_program
  if [ $? -eq 0 ];then
        echo "****  SAM3 MCU programmed!"
        exit 0
   fi
  let count=count+1
done
echo "**** Could not program SAM3 MCU"
exit 1
