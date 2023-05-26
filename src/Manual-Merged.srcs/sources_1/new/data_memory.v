`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: ckr
// 
// Create Date: 2023/05/05 19:51:49
// Design Name: 
// Module Name: data_memory
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


module data_memory(
    input clk,
    input uart_clk,
    input write_en,
    input uart_wen,
    input uart_en,
    input [31:0] addr,
    input [31:0] write_data,
    input [13:0] uart_addr,
    input [31:0] uart_data,
    
    output [31:0] out
    );
    
    RAM_d_64K dmem(
        .clka(uart_en ? uart_clk : ~clk),
        .wea(uart_en ? uart_wen : write_en),
        .addra(uart_en ? uart_addr : addr[15:2]),
        .dina(uart_en ? uart_data : write_data),
        .douta(out)
    );
    
endmodule
