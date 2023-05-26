-- Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
-- Date        : Fri May 26 11:01:44 2023
-- Host        : ArtanisaxLEGION running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               c:/Users/lenovo/Desktop/Manual-Merged/Manual-Merged.srcs/sources_1/ip/cpu_wiz_clk/cpu_wiz_clk_stub.vhdl
-- Design      : cpu_wiz_clk
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a100tfgg484-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cpu_wiz_clk is
  Port ( 
    clk_46MHz : out STD_LOGIC;
    clk_23MHz : out STD_LOGIC;
    clk_10MHz : out STD_LOGIC;
    reset : in STD_LOGIC;
    locked : out STD_LOGIC;
    clk_in1 : in STD_LOGIC
  );

end cpu_wiz_clk;

architecture stub of cpu_wiz_clk is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk_46MHz,clk_23MHz,clk_10MHz,reset,locked,clk_in1";
begin
end;
