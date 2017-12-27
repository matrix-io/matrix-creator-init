#!/bin/bash

cd /usr/share/matrixlabs/matrixio-devices

function reset_voice(){
  echo 26 > /sys/class/gpio/export 2>/dev/null
  echo out > /sys/class/gpio/gpio18/direction
  echo 1 > /sys/class/gpio/gpio18/value
  echo 0 > /sys/class/gpio/gpio18/value
  echo 1 > /sys/class/gpio/gpio18/value 
}

function reset_creator(){
  echo 18 > /sys/class/gpio/export 2>/dev/null
  echo out > /sys/class/gpio/gpio18/direction
  echo 1 > /sys/class/gpio/gpio18/value
  echo 0 > /sys/class/gpio/gpio18/value
  echo 1 > /sys/class/gpio/gpio18/value 
}

function try_program_creator() {
  reset_creator
  sleep 0.1
  xc3sprog -c matrix_creator blob/system_creator.bit -p 1 > /dev/null 2> /dev/null
}

function try_program_voice() {
  reset_voice
  sleep 0.1
  xc3sprog -c matrix_voice blob/bscan_spi_s6lx9_ftg256.bit > /dev/null 2> /dev/null
  reset_voice
  sleep 0.1
  xc3sprog -c matrix_voice -I blob/system_voice.bit > /dev/null 2> /dev/null
}

function update_voice(){
count=0
while [  $count -lt 5 ]; do 
  try_program_voice
  if [ $? -eq 0 ];then
        echo "****  MATRIX Voice FPGA Software has been updated!"
	reset_voice
        exit 0
   fi
  let count=count+1
done
}

function program_creator(){
count=0
while [  $count -lt 5 ]; do
  try_program_creator
  if [ $? -eq 0 ];then
        echo "**** MATRIX Creator FPGA has been programmed!"
	./fpga_info
        exit 0
   fi
  let count=count+1
done
}

function check_voice() {
  COMPARE_VERSION=$(diff <(./fpga_info) <(cat voice.version)|wc -l)
  if [ "$COMPARE_VERSION" == "0" ];then
     echo "*** MATRIX Voice has a updated firmware"
     exit 0
   else #failed
     update_voice
  fi
}

program_creator # If MATRIX Creator has not been detected, try with MATRIX Voice steps
check_voice

echo "**** Could not program FPGA"
exit 1

