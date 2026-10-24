# 4-Bit Unsigned Array Multiplier — SKY130

## 1. Project Overview

This project implements and verifies a synchronous 4-bit unsigned array multiplier using Verilog HDL. The design is synthesized and physically implemented using the SKY130A process design kit and the `sky130_fd_sc_hd` standard-cell library.

**Repository:** https://github.com/Krishnabella/mult4_2026702010

## 2. Design Architecture

- Inputs: `a[3:0]`, `b[3:0]`
- Output: `p[7:0]`
- Clock: `clk`
- Active-low reset: `rst_n`
- Partial products: 16 AND operations
- Arithmetic: full-adder-based array structure
- Registers: input registers and registered output
- Input-to-output latency: two clock cycles

The multiplier generates partial products using AND gates and adds them using full adders to produce the 8-bit product.

## 3. RTL and Verification

Source files:

- `rtl/full_adder.v` — full-adder module
- `rtl/mult_array.v` — multiplier RTL
- `tb/tb_mult.v` — exhaustive multiplier testbench
- `tb/tb_full_adder.v` — full-adder testbench

The multiplier testbench checks all 256 combinations of two 4-bit unsigned inputs, using a 10 ns clock and reset initialization.

**Simulation result:**

`PASS: 256 vectors checked, 0 errors`

Gate-level simulation also passed all 256 test vectors with zero errors.

Additional focused latency evidence: docs/images/mult_example_latency.png
The testbench generates `mult.vcd` for waveform inspection.

## 4. Synthesis

Synthesis script: `synth/synth.tcl`

Deliverables:

- `synth/mult_array_netlist.v`
- `synth/mult_array_stat.rpt`

The synthesized netlist is used for gate-level verification and timing analysis. Refer to the synthesis report for cell statistics and area information.

## 5. Static Timing Analysis

STA script: `sta/sta.tcl`

Technology: SKY130A  
Typical timing corner: `tt_025C_1v80`

At a 10 ns clock period, the reported register-to-register worst slack was approximately **+7.409750 ns**.

The estimated minimum clock period was calculated as:

`Tmin = 10 ns − 7.409750 ns = 2.590250 ns`

The corresponding estimated maximum frequency is approximately **386.06 MHz**.

A verification run at 2.59 ns produced approximately −0.000250 ns slack, consistent with rounding the estimated minimum period down to two decimal places.

Timing reports are stored in `sta/`.

## 6. Physical Design

Tool: LibreLane Classic flow  
PDK: SKY130A  
Standard-cell library: `sky130_fd_sc_hd`  
Floorplan sizing: Absolute  
Die area: 150 µm × 150 µm  
Final clock period: 6.5 ns

The final run is:

`runs/mult4_final_demo/final/`

The flow completed and reported:

- Antenna check: Passed
- LVS: Passed
- DRC: Passed
- Final setup slack: approximately +0.085280 ns
- Standard-cell count: 335
- Final routed wirelength: approximately 2405 µm


The final post-route frequency estimate using the assignment's slack-based formula is approximately:

`1000 / (6.5 − 0.085280) = 155.89 MHz`

Physical-design deliverables:

- `pnr/config.json`
- `pnr/metrics.json`
- `pnr/mult_array.gds`

## 7. Physical-Design Attempts

The following SKY130 clock-period attempts were made:

| Clock period | Result |
|---|---|
| 3.5 ns | Setup violations |
| 5.5 ns | Setup violations |
| 6.0 ns | Setup violations |
| 6.5 ns | Flow completed; final setup slack positive |

An earlier run used the IHP SG13G2 PDK during environment setup. It is not the final result for this SKY130 assignment.

## 8. Reproducibility

The project is organized into the following directories:

- `rtl/` — Verilog design
- `tb/` — simulation testbenches
- `synth/` — synthesis script, netlist, and statistics
- `sta/` — timing-analysis scripts and reports
- `pnr/` — physical-design configuration and final outputs
- `report/` — project report

The final physical-design flow must be run with the SKY130A PDK and `sky130_fd_sc_hd` library selected explicitly. The run directory contains intermediate outputs and is not part of the required final deliverables.

## 9. Conclusion

The 4-bit unsigned array multiplier passed exhaustive RTL and gate-level verification. The SKY130 physical-design flow completed with DRC and LVS passing and positive final setup slack.
4 - bit Array
