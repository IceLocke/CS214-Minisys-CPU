vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xil_defaultlib

vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vlog -work xil_defaultlib -64 \
"../../../../Manual-Merged.srcs/sources_1/ip/uart_bmpg_0/uart_bmpg.v" \
"../../../../Manual-Merged.srcs/sources_1/ip/uart_bmpg_0/upg.v" \
"../../../../Manual-Merged.srcs/sources_1/ip/uart_bmpg_0/sim/uart_bmpg_0.v" \


vlog -work xil_defaultlib \
"glbl.v"

