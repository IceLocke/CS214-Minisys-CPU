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
    
    wire kick_off;
    assign kick_off = ~uart_en | uart_done;

    RAM_64K dmem(
        .clka(kick_off ? ~clk : uart_clk),
        .wea(kick_off ? write_en : 1),
        .addra(kick_off ? addr[15:2] : uart_addr),
        .dina(kick_off ? write_data : uart_data),
        .douta(out)
    );
    
endmodule
