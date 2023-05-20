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
    input uart_done,
    input [31:0] addr,
    input [13:0] uart_addr,
    input [31:0] uart_data,
    
    output [31:0] out
    );
    
    wire kick_off;
    assign kick_off = ~uart_en | uart_done;

    RAM_16K imem(
        .clka(kick_off ? clk : uart_clk),
        .wea(kick_off ? 0 : 1),
        .addra(kick_off ? addr[15:2] : uart_addr),
        .dina(kick_off ? 0 : uart_data),
        .douta(out)
    );
    
endmodule
