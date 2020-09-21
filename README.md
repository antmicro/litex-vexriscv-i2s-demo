I2S driver demo running in Zephyr
==================

I2S sound driver allows endpoint applications to receive and transmit audio PCM frames.

We can distinguish two main parts of the sound system.
 - the I2S core written completely in migen, which can be connected to the litex soc.
   It enables i2s hardware support for sound transmission.
 - the I2S zephyr driver that allows us to collect and transmit sound samples using the 
   real-time operating system.

Devices
-----------------

To use the driver you need the fpga board that is supported by the litex soc build system and the i2s codec.
The driver was tested with the:
 - [Arty-7 board](https://reference.digilentinc.com/reference/programmable-logic/arty-a7/reference-manual) 
 - [Pmod-i2s2](https://reference.digilentinc.com/reference/pmod/pmodi2s2/reference-manual)

The further description will be related to these devices.

Device configuration
-----------------

The I2S2 pmod can be connected to any pmod connector on the Arty-7 board.  
By default, the litex is configured to support pmod on `JA` connector.  
The PMOD I2S2 jumper has to switch the device into a master mode. Put the jumper on the `MST` position.   
This allows the device to generate required signals using its internal circuits.
 
Prerequisites
----------------

### Building the gateware
Clone the repository and submodules:
```bash
git clone https://github.com/antmicro/zephyr-on-litex-vexriscv
cd zephyr-on-litex-vexriscv
git submodule update --init --recursive
./init
./make.py --board=arty --build --with_mmcm --with_i2s --with_ethernet
```

### Building the Zephyr 
Follow this [tutorial](https://github.com/antmicro/zephyr-on-litex-vexriscv-build) to set up the zephyr for litex and than
build the [I2S zephyr example](https://github.com/zephyrproject-rtos/zephyr/tree/master/samples/drivers/i2s/litex)
