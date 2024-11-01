# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    dut._log.info("Test project behavior")

    # Set the input values you want to test
    dut.ui_in.value = 0b0001_0010
    # Wait for one clock cycle to see the output values
    await ClockCycles(dut.clk, 1)
    # The following assersion is just an example of how to check the output values.
    # Change it to match the actual expected output of your module:
    assert dut.uo_out.value == 2

    # Set the input values you want to test
    dut.ui_in.value = 0b0001_0010
    # Wait for one clock cycle to see the output values
    await ClockCycles(dut.clk, 1)
    # The following assersion is just an example of how to check the output values.
    # Change it to match the actual expected output of your module:
    assert dut.uo_out.value == 2

    # Set the input values you want to test
    dut.ui_in.value = 0b0001_0011
    # Wait for one clock cycle to see the output values
    await ClockCycles(dut.clk, 1)
    # The following assersion is just an example of how to check the output values.
    # Change it to match the actual expected output of your module:
    assert dut.uo_out.value == 3
    
    # Set the input values you want to test
    dut.ui_in.value = 0b0001_0100
    # Wait for one clock cycle to see the output values
    await ClockCycles(dut.clk, 1)
    # The following assersion is just an example of how to check the output values.
    # Change it to match the actual expected output of your module:
    assert dut.uo_out.value == 4

    # Set the input values you want to test
    dut.ui_in.value = 0b0001_0101
    # Wait for one clock cycle to see the output values
    await ClockCycles(dut.clk, 1)
    # The following assersion is just an example of how to check the output values.
    # Change it to match the actual expected output of your module:
    assert dut.uo_out.value == 5
