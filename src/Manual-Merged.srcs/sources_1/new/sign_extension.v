`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: kl
// 
// Create Date: 2023/05/14 10:29:20
// Design Name: 
// Module Name: sign_extension
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


module sign_extension(
    input extension_mode,
    input [15:0] immediate_16,
    output [31:0] immediate_32
    );
    assign immediate_32 = {{16{extension_mode && immediate_16[15]}}, immediate_16[15:0]};
endmodule
