#!/bin/bash

cd /usr/share/admobilize/matrix-creator
./fpga-program.bash
./radio-init.bash
./sam3-program.bash
