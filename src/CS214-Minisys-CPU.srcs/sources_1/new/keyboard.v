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
    input       pos,
    input       neg,
    input [9:0] kb,
    
    output reg        kb_done,
    output reg [31:0] value
    );
    
    integer digit;
    reg [9:0] last;

    always @(posedge clk, posedge rst)
        if (rst) begin
            value <= 0;
            digit <= 0;
            last <= 10'b00_0000_0000;
            kb_done <= 1'b0;
        end
//        else if (~kb_done)
//            if (pos || neg || digit == 8) begin  // only allow 8 unsigned digits
//                if (neg)
//                    value <= -value;
//                kb_done <= 1'b1;
//            end
//            else
//                if (~kb_done && kb != last) begin
//                    casez (kb)
//                        10'b00_0000_0001: value <= value*10;
//                        10'b00_0000_001z: value <= value*10+1;
//                        10'b00_0000_01zz: value <= value*10+2;
//                        10'b00_0000_1zzz: value <= value*10+3;
//                        10'b00_0001_zzzz: value <= value*10+4;
//                        10'b00_001z_zzzz: value <= value*10+5;
//                        10'b00_01zz_zzzz: value <= value*10+6;
//                        10'b00_1zzz_zzzz: value <= value*10+7;
//                        10'b01_zzzz_zzzz: value <= value*10+8;
//                        10'b1z_zzzz_zzzz: value <= value*10+9;
//                    endcase
//                    digit <= digit+1;
//                end
endmodule
