#!/bin/bash

CHECKSUM=3891e75fae4509ce520a25d6725520db
LOG_FILE=/tmp/em358-program.log

function super_reset()
{
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

function check_flash_status() {
  openocd -f  cfg/em358_check.cfg 2>&1
}

function try_program() {
  sleep 0.5
  RES=$(openocd -f  cfg/em358.cfg 2>&1 | tee ${LOF_FILE} | grep wrote | wc -l)
  echo $RES
}


for i in 4 17 18 19 20 22 23 27
do
  if [ ! -d /sys/class/gpio/gpio$i ]
  then
    echo $i > /sys/class/gpio/export
  fi
done

check_flash_status
SUM=$(md5sum /tmp/em358_dump | awk  '{printf $1}')

if [ "${CHECKSUM}" = "${SUM}" ]
then 
    echo "EM358 MCU was programmed before. Not programming it again."
    exit 0
fi

super_reset

count=0
while [  $count -lt 10 ]; do
  TEST=$(try_program)
  echo TEST=${TEST}

  if [ "$TEST" == "1" ];
  then
        echo "****  EM358 MCU programmed!"
        break
   fi
  let count=count+1
done


