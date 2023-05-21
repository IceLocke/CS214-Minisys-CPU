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
    
    parameter IDLE = 1'b0;
    parameter PEND = 1'b1;
    
    reg state;
    reg last;
    integer cnt;
    
    always @(posedge clk, posedge rst)
        if (rst) begin
            last <= 1'b0;
            stable <= 1'b0;
            state <= IDLE;
        end
        else
            case (state)
                IDLE:
                    if (button != last) begin
                        stable <= button;
                        last <= button;
                        cnt <= 0;
                        state <= PEND;
                    end
                PEND: 
                    if (cnt < 200000) cnt <= cnt+1;
                    else state <= IDLE;
                default: state <= state;
            endcase
    
endmodule
