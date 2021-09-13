
# matrixio-creator-init

## matrix-creator-start-services
![Build Status](https://drone.matrix.one/api/badges/matrix-io/matrix-creator-init/status.svg)

Source for the matrix-creator-init Debian package. This package programs the FPGA and the SAM3 MCU when the system starts.

## Installation
```
# Add repo and key
curl -L https://apt.matrix.one/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.matrix.one/raspbian $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/matrixlabs.list

# Update packages and install
sudo apt-get update
sudo apt-get upgrade

# Installation
sudo apt install matrixio-creator-init
```
## Documentation
https://matrix-io.github.io/matrix-documentation
