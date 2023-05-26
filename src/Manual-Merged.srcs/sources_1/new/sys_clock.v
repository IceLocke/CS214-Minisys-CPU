`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/21 17:29:05
// Design Name: 
// Module Name: sys_clock
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


module sys_clock(
    input clk,
    input rst,
    output reg sys_clk
    );
    
    parameter UPPER_BOUND = 15'd23000;
    
    reg [15:0] count;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sys_clk <= 0;
            count <= 0;
        end
        else begin
            if (sys_clk) sys_clk <= 0;
            if (count < UPPER_BOUND) count <= count + 1;
            else begin
                sys_clk <= 1;
                count <= 0;
            end
        end
    end
    
endmodule
