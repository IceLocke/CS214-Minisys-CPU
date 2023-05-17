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
    input uart_en,
    input uart_done,
    input [31:0] addr,
    input [31:0] write_data,
    input [13:0] uart_addr,
    input [31:0] uart_data,
    
    output [31:0] out
    );
    
    assign kick_off = uart_en | ;

    RAM_64K dmem(
        .clka(kick_off ? uart_clk: ~clk),
        .wea(kick_off ? 1 : write_en),
        .addra(kick_off ? uart_addr : addr[15:2]),
        .dina(kick_off ? uart_data : write_data),
        .douta(out)
    );
    
endmodule
