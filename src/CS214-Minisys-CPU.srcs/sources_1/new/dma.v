`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: ckr
// 
// Create Date: 2023/05/05 20:31:09
// Design Name: 
// Module Name: dma
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


module dma(
    input         clk,
    input         rst,
    input         io_en,
    input  [31:0] cpu_addr,
    input         cpu_write_en,
    input  [31:0] cpu_write_data,
    input  [31:0] io_addr,
    input         io_write_en,
    input  [31:0] io_write_data,
    
    output reg [31:0] addr,
    output reg        write_en,
    output reg [31:0] write_data,
    output reg [31:0] out
    );
    
    assign addr = io_en ? io_addr : cpu_addr;
    assign write_en = io_en ? cpu_write_en : cpu_write_data;
    assign write_data = io_en ? io_write_data : cpu_write_data;
    
endmodule
