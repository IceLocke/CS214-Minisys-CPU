`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: kl
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


module cpu_clk(
    input rst,
    input clk_in,
    output clk_23MHz,
    output clk_10MHz
);
    clk_wiz_0 cpu_wiz_clock(
        .rst(rst),
        .clk_in1(clk_in),
        .clk_23MHz(clk_23MHz),
        .clk_10MHz(clk_10MHz)
    );
endmodule
