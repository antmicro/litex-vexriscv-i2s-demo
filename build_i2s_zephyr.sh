#!/bin/bash
set -x

main_directory="$(pwd)"
repos_dir="$main_directory/third_party"
binary_dir="$main_directory/binaries"
litex_vexriscv_dir="$repos_dir/zephyr-on-litex-vexriscv"
zephyr_dir="$repos_dir/zephyr"

mkdir -p "$repos_dir"
mkdir -p "$binary_dir"
if [[ ! -d "$litex_vexriscv_dir" ]]
then
    git clone https://github.com/litex-hub/zephyr-on-litex-vexriscv "$litex_vexriscv_dir"
fi

if [[ ! -d "$zephyr_dir" ]]
then
    git clone https://github.com/zephyrproject-rtos/zephyr "$zephyr_dir"
fi

# prepare the litex-buildenv 
cd litex-buildenv
# configure target
export CPU=vexriscv
export CPU_VARIANT=full
export PLATFORM=arty
export FIRMWARE=zephyr
export TARGET=base

./scripts/download-env.sh
source scripts/enter-env.sh


# build the zephyr-on-litexvexriscv
cd "$litex_vexriscv_dir"
./make.py --board=arty --build --with_mmcm --with_i2s --with_ethernet
cp 'build/arty/gateware/arty.bit' "$binary_dir"

#build i2s example with zephyr
export ZEPHYR_TOOLCHAIN_VARIANT="zephyr"
export BOARD="arty_litex_vexriscv"
source "$zephyr_dir/zephyr-env.sh"
cd "$zephyr_dir/samples/drivers/i2s/litex/"
mkdir -p build && cd build
cmake -DBOARD=litex_vexriscv ..
make
cp 'zephyr/zephyr.bin' "$binary_dir"
