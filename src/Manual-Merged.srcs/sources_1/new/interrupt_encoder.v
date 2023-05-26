`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/18 15:26:32
// Design Name: 
// Module Name: interrupt_encoder
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

module interrupt_encoder(
    input [7:0] source,
    output reg [3:0] interrupt
    );
    
    always @(*) begin
        casez (source)
            8'b???????1: interrupt <= 1;
            8'b??????10: interrupt <= 2;
            8'b?????100: interrupt <= 3;
            8'b????1000: interrupt <= 4;
            8'b???10000: interrupt <= 5;
            8'b??100000: interrupt <= 6;
            8'b?1000000: interrupt <= 7;
            8'b10000000: interrupt <= 8;
            default:     interrupt <= 0;
        endcase
    end
    
endmodule
