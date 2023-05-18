`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: ckr
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
    input uart_clk,
    input uart_en,
    input [31:0] addr,
    input [13:0] uart_addr,
    input [31:0] uart_data,
    
    output [31:0] out
    );

    RAM_16K imem(
        .clka(uart_en ? uart_clk : ~clk),
        .wea(uart_en ? 1 : 0),
        .addra(uart_en ? uart_addr : addr[15:2]),
        .dina(uart_en ? uart_data : 0),
        .douta(out)
    );
    
endmodule
