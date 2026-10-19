# SKY130 typical-corner Liberty file
set lib $::env(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

# Read the timing library
read_liberty $lib

# Read and link the synthesized gate-level netlist
read_verilog synth/mult_array_netlist.v
link_design mult_array

# Clock period: 10 ns
set T 10.0

# Define the clock
create_clock -name clk -period $T [get_ports clk]

# Input arrival delay
set_input_delay 1.0 -clock clk [delete_from_list [all_inputs] [get_ports clk]]

# Output required delay
set_output_delay 1.0 -clock clk [all_outputs]

# Report worst setup slack
report_worst_slack -max -digit 6

# Save the detailed critical-path report
report_checks -path_delay max -digits 3 > sta/mult_array_timing.rpt
