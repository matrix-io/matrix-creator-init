#!/bin/bash

LOG_FILE=/tmp/sam3-program.log

function super_reset()
{
  # gpio19 - EM358 nBOOTMODE (active low)
  # gpio18 - mcu power
  # gpio20 - EM_NRST - EM3588 RESET (active low)
  # gpio23 - EM3588 POWER ENABLE

  # Set out mode  
  for j in 18 19 20 23
  do
    echo out > /sys/class/gpio/gpio$j/direction
  done

  for k in 4 17 22 27
  do
    echo in > /sys/class/gpio/gpio$k/direction
  done

  #Power EM_358 OFF 
  echo 1 > /sys/class/gpio/gpio18/value
  echo 1 > /sys/class/gpio/gpio19/value
  echo 1 > /sys/class/gpio/gpio20/value
  echo 0 > /sys/class/gpio/gpio23/value
  sleep 0.5

  #Power ON
  echo 1 > /sys/class/gpio/gpio23/value
  sleep 0.5

  echo 0 > /sys/class/gpio/gpio18/value
  echo 0 > /sys/class/gpio/gpio19/value
  echo 0 > /sys/class/gpio/gpio20/value

  sleep 0.5
  echo 1 > /sys/class/gpio/gpio18/value
  echo 1 > /sys/class/gpio/gpio20/value

  sleep 0.5
  echo 1 > /sys/class/gpio/gpio19/value
}

function reset_mcu() {
  if [ ! -d /sys/class/gpio/gpio18 ]
  then
    echo 18 > /sys/class/gpio/export
  fi
  echo out > /sys/class/gpio/gpio18/direction
  echo 1 > /sys/class/gpio/gpio18/value
  echo 0 > /sys/class/gpio/gpio18/value
  echo 1 > /sys/class/gpio/gpio18/value
}

function try_program() {
  reset_mcu
  sleep 0.1

  RES=$(openocd -f cfg/sam3s_rpi_sysfs.cfg 2>&1 | tee ${LOG_FILE} | grep wrote | wc -l)
  echo $RES
  
  sleep 0.5
  reset_mcu  
}

function enable_program() {
  echo 1 > /sys/class/gpio/gpio19/value
  echo 0 > /sys/class/gpio/gpio20/value
  echo 1 > /sys/class/gpio/gpio20/value
  echo "Running the program instead of the bootloader" 
}

function check_firmware() {
 COMPARE_VERSION=$(diff <(./firmware_info) <(cat mcu_firmware.version)|wc -l)

 if [ "$COMPARE_VERSION" == "0" ];then
  echo 1
 else #failed
  echo 0 
 fi
}

for i in 4 17 18 19 20 22 23 27
do
  if [ ! -d /sys/class/gpio/gpio$i ]
  then
    echo $i > /sys/class/gpio/export
  fi
done

super_reset 
reset_mcu

CHECK=$(check_firmware)
if [ "$CHECK" == "1" ]
then
  reset_mcu
  enable_program
  echo "SAM3 MCU was programmed before. Not programming it again."
  exit 0
fi

count=0
while [  $count -lt 30 ]; do
  TEST=$(try_program)
  if [ "$TEST" == "1" ];then
        CHECK=$(check_firmware)
        if [ "$CHECK" == "1" ];then
          echo "****  SAM3 MCU programmed!"
          reset_mcu
          exit 0
        fi
   fi
  let count=count+1
done
echo "**** Could not program SAM3 MCU, you must be check the logfile ${LOG_FILE}"
exit 1
