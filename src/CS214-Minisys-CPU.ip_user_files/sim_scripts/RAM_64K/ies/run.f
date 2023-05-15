-makelib ies_lib/xil_defaultlib -sv \
  "D:/Vivado/Vivado/2017.4/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib ies_lib/xpm \
  "D:/Vivado/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/blk_mem_gen_v8_4_1 \
  "../../../ipstatic/simulation/blk_mem_gen_v8_4.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../CS214-Minisys-CPU.srcs/sources_1/ip/RAM_64K/sim/RAM_64K.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

