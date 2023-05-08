`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
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
    input [31:0] addr,
    input write_en,
    input [31:0] write_data,
    output [31:0] out
    );
    
    RAM_64K dmem(
        .clka(!clk),
        .wea(write_en),
        .addra(addr[15:2]),
        .dina(write_data),
        .douta(out)
    );
    
endmodule
