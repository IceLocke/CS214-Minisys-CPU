`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/25 21:01:22
// Design Name: 
// Module Name: iotest
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


module iotest();
    reg clk = 0;
    reg rst = 0;
    reg uart_en = 0;
    reg ack;
    reg [7:0] data = 2333;
    
    cpu_top top(
        .clk_in(clk),
        .rst(rst),
        .data_switch(data),
        .ack(ack),
        .uart_en(0)
    );

    always #1 clk = ~clk;

    initial begin
        #380 rst = 1;
        #60 rst = 0;
        #920 ack = 1;
        #700 ack = 0;
    end

endmodule
