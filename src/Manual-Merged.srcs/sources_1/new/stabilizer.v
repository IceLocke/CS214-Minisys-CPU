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
    parameter WORK = 1'b1;
    parameter TIME = 1000000;

    reg state;
    reg last;
    integer cnt;
    
    always @(posedge clk, posedge rst)
        if (rst) begin
            last <= 1'b0;
            stable <= 1'b0;
            cnt <= 0;
            state <= IDLE;
        end
        else
            case (state)
                IDLE:
                    if (button != last) begin  // once the button changes
                        stable <= button;
                        cnt <= 0;
                        state <= WORK;
                    end
                WORK:
                    if (cnt < TIME)  // force it to remain for a certain time
                        cnt <= cnt+1;
                    else begin
                        stable <= button;
                        last <= stable;
                        state <= IDLE;
                    end
            endcase
    
endmodule
