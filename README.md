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


# edit / usecase 
- Using *_ptr_gray_next Can Be Justified instead of *_ptr_gray
- This is useful in:
- Pipelined write logic
- Multi-stage FIFOs
- Zero-latency systems, where stalling early is better than risking corruption
- CONS OF USING THE ABOVE MENTIONED TECHNIQUE
- Over-conservatism: It may block a write one cycle earlier than truly needed — particularly if the read pointer moves in the same cycle.
- Wasted space: One location in the FIFO may remain unused (this is the typical “one-slot empty” problem in circular buffers)

