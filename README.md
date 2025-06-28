# Asynchronous-FIFO

An efficient, dual-clock asynchronous FIFO implemented in Verilog using Gray code pointer synchronization and safe Clock Domain Crossing (CDC) techniques.

---

## Overview

The `agray_sync_fifo` module supports read and write operations on independent clock domains. Key techniques used:

- Gray code for pointer synchronization across domains  
- Double flip-flop synchronizers to avoid metastability  
- Parameterizable `fifo_depth` and `data_width`  
- Simple Verilog RTL design, suitable for FPGA synthesis

---

## Features

- Dual clock domain support (`wr_clk`, `rd_clk`)
- Safe CDC via double synchronizers
- Gray-coded pointer comparison
- Parameterized depth and width
- Full and empty flag logic
- Compact memory usage with register-based storage

---

## Test Suggestions

To verify the design, test for:

- Normal read/write behavior with different clocks
- Full and empty conditions
- Pointer wrap-around scenarios
- Cross-domain synchronization integrity

---

## Usage

Include `agray_sync_fifo.v` in your Verilog project.  
You may write a testbench (`agray_sync_fifo_tb.v`) to simulate read/write operations and observe full/empty flags.

---

