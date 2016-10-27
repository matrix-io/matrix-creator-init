#!/bin/bash

LOG_FILE=/tmp/sam3-program.log

function super_reset()
{
  #Set EM_Enable
  echo 23 > /sys/class/gpio/export 
  echo out > /sys/class/gpio/gpio23/direction 

  #Set EM_BOOTMODE
  echo 19 > /sys/class/gpio/export
  echo out > /sys/class/gpio/gpio19/direction

  #set EM_nRST
  echo 18 > /sys/class/gpio/export
  echo 20 > /sys/class/gpio/export
  echo out > /sys/class/gpio/gpio18/direction
  echo out > /sys/class/gpio/gpio20/direction

  #Set TCK
  echo 17 > /sys/class/gpio/export
  echo in > /sys/class/gpio/gpio17/direction

  #Set TDO
  echo 27 > /sys/class/gpio/export
  echo in > /sys/class/gpio/gpio27/direction

  #Set TDI
  echo 22 > /sys/class/gpio/export
  echo in > /sys/class/gpio/gpio22/direction

  #Set TMS
  echo 4 > /sys/class/gpio/export
  echo in > /sys/class/gpio/gpio4/direction

  #Set EM_BOOTMODE
  echo 18 > /sys/class/gpio/export
  echo out > /sys/class/gpio/gpio18/direction

  #Power OFF 
  echo 0 > /sys/class/gpio/gpio23/value
  echo 1 > /sys/class/gpio/gpio18/value
  echo 1 > /sys/class/gpio/gpio20/value
  echo 1 > /sys/class/gpio/gpio19/value
  sleep 0.5

  #Power ON
  echo 1 > /sys/class/gpio/gpio23/value
  sleep 0.5

  echo 0 > /sys/class/gpio/gpio18/value
  echo 0 > /sys/class/gpio/gpio20/value
  echo 0 > /sys/class/gpio/gpio19/value

  sleep 0.5
  echo 1 > /sys/class/gpio/gpio18/value
  echo 1 > /sys/class/gpio/gpio20/value

  sleep 0.5
  echo 1 > /sys/class/gpio/gpio19/value
}

function reset_mcu() {
  echo 18 > /sys/class/gpio/export 2>/dev/null
  echo out > /sys/class/gpio/gpio18/direction
  echo 1 > /sys/class/gpio/gpio18/value
  echo 0 > /sys/class/gpio/gpio18/value
  echo 1 > /sys/class/gpio/gpio18/value
}

if [[ -f /usr/share/admobilize/matrix-creator/sam3-program.bash.done ]] ; then
    echo "SAM3 MCU was programmed before. Not programming it again."
    exit 0
fi

cd /usr/share/admobilize/matrix-creator

function try_program() {
  reset_mcu
  sleep 0.1

  IS_PI1=$(cat /proc/cpuinfo | grep  BCM2708 | wc -l)
  if [ $IS_PI1 -eq 1 ];then
    RES=$(openocd -f cfg/sam3s_pi1.cfg 2>&1 | tee ${LOG_FILE} | grep wrote | wc -l)
  else
    RES=$(openocd -f cfg/sam3s_pi2_pi3.cfg 2>&1 | tee ${LOG_FILE} | grep wrote | wc -l)
  fi
  echo $RES
}

function check_firmware() {
 COMPARE_VERSION=$(diff <(./firmware_info) <(cat mcu_firmware.version)|wc -l)

 if [ "$COMPARE_VERSION" == "0" ];then
  echo 1
 else #failed
  echo 0 
 fi
}


super_reset 2>/dev/null

count=0
while [  $count -lt 10 ]; do
  TEST=$(try_program)
  if [ "$TEST" == "1" ];then
        CHECK=$(check_firmware)
        if [ "$CHECK" == "1" ];then
          echo "****  SAM3 MCU programmed!"
          touch /usr/share/admobilize/matrix-creator/sam3-program.bash.done
          exit 0
        fi
   fi
  let count=count+1
done
echo "**** Could not program SAM3 MCU, you must be check the logfile ${LOG_FILE}"
exit 1
