`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/20 19:13:31
// Design Name: 
// Module Name: stabilizer
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


module stabilizer(
        input        clk,
        input        rst,
        input        button,
        
        output reg stable
    );
    
    reg last;
    reg [4:0] cnt;
    
    
    
    always @(posedge clk, posedge rst)
        if (rst) begin
            last <= 1'b0;
            stable <= 1'b0;
            
        end
        
endmodule
