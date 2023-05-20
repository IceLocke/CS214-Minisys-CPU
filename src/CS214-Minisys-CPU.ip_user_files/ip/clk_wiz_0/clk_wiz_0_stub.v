// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
// Date        : Sat May 20 13:58:25 2023
// Host        : LAPTOP-DeerInForest running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/11432/Desktop/CS214tool/CS214-Minisys-CPU/src/CS214-Minisys-CPU.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_stub.v
// Design      : clk_wiz_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tfgg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_wiz_0(clk_100MHz, clk_10MHz, clk_23MHz, reset, locked, 
  clk_in1)
/* synthesis syn_black_box black_box_pad_pin="clk_100MHz,clk_10MHz,clk_23MHz,reset,locked,clk_in1" */;
  output clk_100MHz;
  output clk_10MHz;
  output clk_23MHz;
  input reset;
  output locked;
  input clk_in1;
endmodule
