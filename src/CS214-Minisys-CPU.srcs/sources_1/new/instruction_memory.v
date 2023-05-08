`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/05 20:25:40
// Design Name: 
// Module Name: instruction_memory
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


module instruction_memory(
    input clk,
    input [31:0] addr,
    input uart_en,
    input [31:0] uart_addr,
    input [31:0] uart_data,
    output [31:0] out
    );
    
    RAM_16K imem(
        .clka(!clk),
        .wea(0),
        .addra(addr[13:2]),
        .dina(0),
        .douta(out)
    );
    
endmodule
