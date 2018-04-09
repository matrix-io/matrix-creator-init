/*
 * Copyright 2016 <Admobilize>
 * MATRIX Labs  [http://creator.matrix.one]
 * This file is part of MATRIX Creator HAL
 *
 * MATRIX Creator HAL is free software: you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <iostream>
#include <iomanip>

#include <matrix_hal/matrixio_bus.h>

namespace hal = matrix_hal;

struct fpga_version {
  uint32_t identify;
  uint32_t version;
};

int main() {
  hal::MatrixIOBus bus;
  bus.Init();
     
  std::cout << "FPGA IDENTIFY = " << std::hex << bus.MatrixName() << std::endl;
  std::cout << "FPGA VERSION = " << std::hex << bus.MatrixVersion() << std::endl;

  return 0;
}
