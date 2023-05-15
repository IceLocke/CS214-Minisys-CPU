`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: kl
// 
// Create Date: 2023/05/10 16:05:47
// Design Name: 
// Module Name: cpu_top
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


module cpu_top(
    input           clk,
    input           rst,
    input [2:0]     state_switch,
    input [7:0]     data_switch,
    input [15:0]    keyboard,
    input           uart_enable,
    input           uart_in,
    output          led_sign,
    output [7:0]    led_data,
    output [7:0]    seg_en,
    output [7:0]    seg_left,
    output [7:0]    seg_right
);
    
    reg [31:0] pc;
    
endmodule
