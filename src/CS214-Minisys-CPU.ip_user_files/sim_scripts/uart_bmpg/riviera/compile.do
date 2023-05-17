vlib work
vlib riviera

vlib riviera/xil_defaultlib
vlib riviera/xpm

vmap xil_defaultlib riviera/xil_defaultlib
vmap xpm riviera/xpm

vlog -work xil_defaultlib  -sv2k12 \
"D:/Xilinx/Vivado/2017.4/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93 \
"D:/Xilinx/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -v2k5 \
"../../../../CS214-Minisys-CPU.srcs/sources_1/ip/uart_bmpg/uart_bmpg.v" \
"../../../../CS214-Minisys-CPU.srcs/sources_1/ip/uart_bmpg/upg.v" \
"../../../../CS214-Minisys-CPU.srcs/sources_1/ip/uart_bmpg/sim/uart_bmpg.v" \

vlog -work xil_defaultlib \
"glbl.v"

