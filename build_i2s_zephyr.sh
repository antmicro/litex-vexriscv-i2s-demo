#!/bin/bash
set -x

main_directory="$(pwd)"
binary_dir="$main_directory/binaries"
litex_vexriscv_dir="$main_directory/zephyr-on-litex-vexriscv"
zephyr_dir="$main_directory/zephyr"

mkdir -p "$binary_dir"

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
