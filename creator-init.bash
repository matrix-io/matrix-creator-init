#!/bin/bash

cd /usr/share/admobilize/matrix-creator
./fpga-program.bash
./em358-program.bash
./radio-init.bash
./sam3-program.bash
