echo 5 > /sys/class/gpio/export 
echo out > /sys/class/gpio/gpio5/direction
echo 0 > /sys/class/gpio/gpio5/value


echo 13 > /sys/class/gpio/export 
echo out > /sys/class/gpio/gpio13/direction
echo 0 > /sys/class/gpio/gpio13/value

echo 21 > /sys/class/gpio/export 
echo out > /sys/class/gpio/gpio21/direction
echo 0 > /sys/class/gpio/gpio21/value
