`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/20 14:56:36
// Design Name: 
// Module Name: Seg_Test
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


module Seg_Test();
    reg clk;
    reg rst;
    integer data;
    
    wire [7:0] en;
    wire [7:0] out;
    
    seg seg_instance(
        .clk(clk),
        .rst(rst),
        .data(data),
        .en(en),
        .out(out)
    );

    always #10 clk = ~clk; 

    initial begin
        clk = 1'b0;
        rst = 1'b1;
        data = 0;

        #100 rst = 1'b0;

        #500 data = 87654321;
    end
endmodule
