# Asynchronous-fifo

An efficient, dual-clock asynchronous FIFO implementation in Verilog using Gray code pointer synchronization and proper CDC (Clock Domain Crossing) techniques.

# overview

The agray_sync_fifo is an asynchronous FIFO module where read and write operations are clocked by different clocks. It uses: 
Gray code pointers to handle synchronization across domains. 
Double-flip-flop synchronizers for metastability mitigation.Parameterized depth and data width. 
Verilog RTL (Register Transfer Level) style for easy synthesis on FPGAs.

# Features

Dual clock domain support (wr_clk, rd_clk)
Proper CDC (clock domain crossing) via double synchronizers
Gray code pointer logic for safe cross-domain comparison
Parameterizable data_width and fifo_depth
Full and Empty flag detection
Memory-efficient design with reg-based storage

# 🧪 Test Suggestions

Write a testbench to validate:
Normal read/write flow with async clocks
Full and empty conditions
Pointer wraparound behavior
CDC correctness (no data corruption at any point)
