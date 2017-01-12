#!/bin/bash

for i in 5 13 21
do
  if [ ! -d /sys/class/gpio/gpio$i ]
  then
    echo $i > /sys/class/gpio/export
    echo out > /sys/class/gpio/gpio${i}/direction
  fi
done

echo 1 > /sys/class/gpio/gpio5/value
echo 0 > /sys/class/gpio/gpio13/value
echo 0 > /sys/class/gpio/gpio21/value
