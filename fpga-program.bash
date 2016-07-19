#!/bin/bash

cd /usr/share/admobilize/matrix-creator

function try_program() {
    xc3sprog -c matrix_pi blob/system.bit -p 1
}


count=0
while [  $count -lt 10 ]; do
  try_program
  if [ $? -eq 0 ];then
        echo "****  FPGA programmed!"
        exit 0
   fi
  let count=count+1
done
echo "**** Could not program FPGA"
exit 1
