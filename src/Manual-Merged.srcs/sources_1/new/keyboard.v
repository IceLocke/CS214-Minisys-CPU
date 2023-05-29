`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: ckr
// 
// Create Date: 2023/05/19 22:55:29
// Design Name: 
// Module Name: keyboard
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


module keyboard(
    input       clk,
    input       rst,
    input [3:0] col,
    
    output reg [3:0]  row,
    output reg [15:0] kb
    );
    
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            kb <= 16'b0;
            row <= 4'b1110;
        end
        else begin
            case (row)  // scan rows to get columns
                4'b0111: begin
                    kb[15:12] <= ~col;
                    row <= 4'b1011;
                end
                4'b1011: begin
                    kb[11:8] <= ~col;
                    row <= 4'b1101;
                end
                4'b1101: begin
                    kb[7:4] <= ~col;
                    row <= 4'b1110;
                end
                4'b1110: begin
                    kb[3:0] <= ~col;
                    row <= 4'b0111;
                end
                default: begin
                    kb <= 16'b0;
                    row <= 4'b0111;
                end
            endcase
        end
    end
    
endmodule