#!/bin/bash

cd /usr/share/admobilize/matrix-creator

function detect_device(){
  MATRIX_DEVICE=$(./fpga_info | grep IDENTIFY | cut -f 3 -d ' ')
}

./fpga-program.bash
detect_device

case "${MATRIX_DEVICE}" in
  "05c344e8")  
     echo "*** MATRIX Creator initial process has been launched"
    ./em358-program.bash
    ./radio-init.bash
    ./sam3-program.bash
    ;;
  "6032bad2")
    echo "*** MATRIX Voice initial process has been launched"
    ;;
esac

exit 0
