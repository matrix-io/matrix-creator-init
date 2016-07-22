#!/bin/bash

echo 5 > /sys/class/gpio/export 
sleep 0.1
echo out > /sys/class/gpio/gpio5/direction
sleep 0.1
echo 0 > /sys/class/gpio/gpio5/value
sleep 0.1

echo 13 > /sys/class/gpio/export 
sleep 0.1
echo out > /sys/class/gpio/gpio13/direction
sleep 0.1
echo 0 > /sys/class/gpio/gpio13/value
sleep 0.1

echo 21 > /sys/class/gpio/export 
sleep 0.1
echo out > /sys/class/gpio/gpio21/direction
sleep 0.1
echo 0 > /sys/class/gpio/gpio21/value
