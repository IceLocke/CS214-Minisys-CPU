`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/07 20:22:38
// Design Name: 
// Module Name: IO_Test
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


module IO_Test();
    reg        clk;
    reg        rst;
    reg [2:0]  state_switch;
    reg [7:0]  data_switch;
    reg [15:0] keyboard;
    reg        uart_en;
    reg        uart_in;
    reg        io_en;
    
    wire [31:0] addr;
    wire        write_en;
    wire [31:0] write_data;
    wire [31:0] mem_out;
    wire        req;
    wire        led_sign;
    wire [7:0]  led_data;
    wire [7:0]  seg_en;
    wire [7:0]  seg_left;
    wire [7:0]  seg_right;
    
    wire [1:0]  test_state;
    wire [31:0] test_cnt;
    
    io io_ctrl(
        .clk(clk),
        .rst(rst),
        .state_switch(state_switch),
        .data_switch(data_switch),
        .keyboard(keyboard),
        .uart_en(uart_en),
        .uart_in(uart_in),
        .io_en(io_en),
        .mem_out(mem_out),
        .req(req),
        .addr(addr),
        .write_en(write_en),
        .write_data(write_data),
        .led_sign(led_sign),
        .led_data(led_data),
        .seg_en(seg_en),
        .seg_left(seg_left),
        .seg_right(seg_right),
        .test_state(test_state),
        .test_cnt(test_cnt)
    );
            
    data_memory dmem(
        .clk(clk),
        .addr(addr),
        .write_en(write_en),
        .write_data(write_data),
        .out(mem_out)
    ); 
    
    always #5 clk = !clk;
    
    initial begin
        #20 begin
            clk = 0;
            rst = 1;
            state_switch = 1;
            data_switch = 2;
            keyboard = 3;
            uart_en = 0;
            uart_in = 0;
            io_en = 0;
        end
        
        #100 begin 
            rst = 0;
            io_en = 1;
        end
        
        #1500 io_en = 0;
        
        #2000 begin
            io_en = 1;
            state_switch = 10;
            data_switch = 11;
            keyboard = 12;
        end
        
    end

endmodule
