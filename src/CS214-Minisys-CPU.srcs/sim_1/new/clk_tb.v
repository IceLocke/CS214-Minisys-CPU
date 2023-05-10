`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/10 08:45:41
// Design Name: 
// Module Name: clk_tb
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


module clk_tb();
    reg clk_in;
    wire clk_out;
    cpu_clk cpu_clk_tb(
        .clk_in(clk_in),
        .clk_out(clk_out)
    );
    
    always #5 clk_in = ~clk_in;
    initial begin
        #5 clk_in = 1'b0;
    end
endmodule
