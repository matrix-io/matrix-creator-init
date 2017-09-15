#!/bin/bash

for i in 21 16
do
  if [ ! -d /sys/class/gpio/gpio$i ]
  then
    echo $i > /sys/class/gpio/export
    echo out > /sys/class/gpio/gpio${i}/direction
  fi
done

echo 0 > /sys/class/gpio/gpio16/value
echo 1 > /sys/class/gpio/gpio21/value
