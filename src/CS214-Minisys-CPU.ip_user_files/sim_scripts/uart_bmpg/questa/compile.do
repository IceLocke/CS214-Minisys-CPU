vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xil_defaultlib
vlib questa_lib/msim/xpm

vmap xil_defaultlib questa_lib/msim/xil_defaultlib
vmap xpm questa_lib/msim/xpm

vlog -work xil_defaultlib -64 -sv \
"D:/Xilinx/Vivado/2017.4/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93 \
"D:/Xilinx/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib -64 \
"../../../../CS214-Minisys-CPU.srcs/sources_1/ip/uart_bmpg/uart_bmpg.v" \
"../../../../CS214-Minisys-CPU.srcs/sources_1/ip/uart_bmpg/upg.v" \
"../../../../CS214-Minisys-CPU.srcs/sources_1/ip/uart_bmpg/sim/uart_bmpg.v" \

vlog -work xil_defaultlib \
"glbl.v"

