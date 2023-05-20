-makelib ies_lib/xil_defaultlib -sv \
  "D:/Xilinx/Vivado/2017.4/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "D:/Xilinx/Vivado/2017.4/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib ies_lib/xpm \
  "D:/Xilinx/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../CS214-Minisys-CPU.srcs/sources_1/ip/uartbmpg/uart_bmpg.v" \
  "../../../../CS214-Minisys-CPU.srcs/sources_1/ip/uartbmpg/upg.v" \
  "../../../../CS214-Minisys-CPU.srcs/sources_1/ip/uartbmpg/sim/uartbmpg.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

