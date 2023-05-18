`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: ckr
// 
// Create Date: 2023/05/06 22:24:28
// Design Name: 
// Module Name: io
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


module io(
    input        clk,
    input        rst,
    input        uart_clk,
    input        uart_rst,
    input [2:0]  state_switch,
    input [7:0]	 data_switch,
    input [15:0] keyboard,
    input [31:0] mem_out,
    
    output reg        io_en,
    output reg [31:0] addr,
    output reg        write_en,
    output reg [31:0] write_data,
    output reg        uart_en,
    output reg        uart_done,
    output [13:0]     uart_addr,
    output [31:0]     uart_data,
    output reg        led_sign,
    output reg [7:0]  led_data,
    output reg [7:0]  seg_en,
    output reg [7:0]  seg_left,
    output reg [7:0]  seg_right
    );
    
    parameter TIME = 1000;
    parameter BASE = 0;
    parameter IDLE = 2'b00;
    parameter WORK = 2'b01;
    parameter UART = 2'b10;
    parameter DONE = 2'b11;
    
    integer cnt;
    reg [1:0] state;
    
    wire [14:0] uart_addr_out;
    uart uart_core(
        .upg_clk_i(uart_clk),
        .upg_rst_i(uart_rst),
        .upg_adr_o(uart_addr_out),
        .upg_done_o(uart_done)
    );
    
    always @(posedge clk, posedge uart_rst, posedge rst)
        if (rst) begin
            led_sign = 1'b0;
            led_data = 0;
            seg_en = 8'b1111_1111;
            seg_left = 8'b1111_1111;
            seg_right = 8'b1111_1111;
            cnt <= 0;
            io_en <= 1'b0;
            uart_en <= 1'b0;
            write_en <= 1'b0;
            state <= IDLE;
        end
        else
            case(state)
                IDLE: begin
                    if (uart_rst) begin
                        uart_en <= 1'b1;
                        cnt <= 0;
                        io_en <= 1'b0;
                        state <= UART;
                    end
                    else if (cnt == TIME) begin
                            state <= WORK;
                            addr <= BASE;
                            write_en <= 1'b1;
                            write_data <= state_switch;
                            state <= WORK;
                        end
                        else cnt <= cnt+1;
                end
                WORK: begin
                    case(cnt)
                        TIME: write_data <= data_switch;
                        TIME+1: write_data <= keyboard;
                        TIME+2: begin
                            write_en <= 1'b0;
                            led_sign <= mem_out[0];
                        end
                        TIME+3: led_data <= mem_out[7:0];
                        TIME+4: seg_en <= mem_out[7:0];
                        TIME+5: seg_left <= mem_out[7:0];
                        TIME+6: begin
                            seg_right <= mem_out[7:0];
                            io_en <= 1'b0;
                            cnt <= 0;
                            state <= IDLE;
                        end
                    endcase
                    cnt <= cnt+1;
                    addr <= addr+4;
                end
                UART:
                    if (uart_done) begin
                        uart_en <= 1'b0;
                        state <= 0;
                    end
            endcase
endmodule