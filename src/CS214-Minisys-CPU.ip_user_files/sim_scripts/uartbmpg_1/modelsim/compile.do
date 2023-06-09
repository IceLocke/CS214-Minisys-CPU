vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib
vlib modelsim_lib/msim/xpm

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib
vmap xpm modelsim_lib/msim/xpm

vlog -work xil_defaultlib -64 -incr -sv \
"D:/Vivado/Vivado/2017.4/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"D:/Vivado/Vivado/2017.4/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93 \
"D:/Vivado/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib -64 -incr \
"../../../../CS214-Minisys-CPU.srcs/sources_1/ip/uartbmpg_1/uart_bmpg.v" \
"../../../../CS214-Minisys-CPU.srcs/sources_1/ip/uartbmpg_1/upg.v" \
"../../../../CS214-Minisys-CPU.srcs/sources_1/ip/uartbmpg_1/sim/uartbmpg.v" \

vlog -work xil_defaultlib \
"glbl.v"

