vlib work
vlib activehdl

vlib activehdl/xil_defaultlib
vlib activehdl/xpm

vmap xil_defaultlib activehdl/xil_defaultlib
vmap xpm activehdl/xpm

vlog -work xil_defaultlib  -sv2k12 \
"D:/Xilinx/Vivado/2017.4/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm -93 \
"D:/Xilinx/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -v2k5 \
"../../../../CS214-Minisys-CPU.srcs/sources_1/ip/uart/uart_bmpg.v" \
"../../../../CS214-Minisys-CPU.srcs/sources_1/ip/uart/upg.v" \
"../../../../CS214-Minisys-CPU.srcs/sources_1/ip/uart/sim/uart.v" \

vlog -work xil_defaultlib \
"glbl.v"

