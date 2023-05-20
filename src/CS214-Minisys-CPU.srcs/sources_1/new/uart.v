`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: ckr
// 
// Create Date: 2023/05/20 15:54:25
// Design Name: 
// Module Name: uart
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


module uart(
    input uart_clk,
    input uart_rst,
    
    output        uart_i,
    output        uart_d,
    output [13:0] uart_addr,
    output [31:0] uart_data,
    output        uart_done
    );
    
    wire [14:0] uart_addr_out;
    assign uart_addr = uart_addr_out[13:0];
    assign uart_i = ~uart_done & ~uart_addr_out[14];
    assign uart_d = ~uart_done & uart_addr_out[14];
    
    uartbmpg uart_ip(
        .upg_clk_i(uart_clk),
        .upg_rst_i(uart_rst),
        .upg_adr_o(uart_addr_out),
        .upg_done_o(uart_done)
    );
endmodule
