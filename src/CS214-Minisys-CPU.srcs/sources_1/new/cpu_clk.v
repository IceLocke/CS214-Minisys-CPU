`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/10 08:30:19
// Design Name: 
// Module Name: cpu_clk
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cpu_clk(clk_in, clk_out);
    input clk_in;
    output clk_out;
    clk_wiz_0 cpu_wiz_clock(
        .clk_out1(clk_out),
        .clk_in1(clk_in)
    );
endmodule
