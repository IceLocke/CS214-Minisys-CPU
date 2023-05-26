`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/25 23:05:48
// Design Name: 
// Module Name: uarttest
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


module uarttest();
    reg clk = 0;
    reg rst = 0;
    reg uart_en = 1;
    reg ack;
    reg [7:0] data = 2333;
    reg uart_i = 1;
    
    
    cpu_top top(
        .clk_in(clk),
        .rst(rst),
        .data_switch(data),
        .ack(ack),
        .uart_en(uart_en),
        .uart_i(uart_i)
    );
    
    always #1 clk = ~clk;
    
    initial begin
        #320 rst = 1;
        #60 rst = 0;
        #920 ack = 1;
        #700 ack = 0;
    end
    
endmodule
