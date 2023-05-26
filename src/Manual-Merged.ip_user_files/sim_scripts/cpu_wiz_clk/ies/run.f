-makelib ies_lib/xil_defaultlib -sv \
  "D:/Xilinx/Vivado/2017.4/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
-endlib
-makelib ies_lib/xpm \
  "D:/Xilinx/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../Manual-Merged.srcs/sources_1/ip/cpu_wiz_clk/cpu_wiz_clk_clk_wiz.v" \
  "../../../../Manual-Merged.srcs/sources_1/ip/cpu_wiz_clk/cpu_wiz_clk.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

