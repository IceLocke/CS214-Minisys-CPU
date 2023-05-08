`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
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
    input [2:0]  state_switch,
    input [7:0]	 data_switch,
    input [15:0] keyboard,
    input        uart_en,
    input        uart_in,
    input        io_en,
    input [31:0] mem_out,
    
    output reg        req,
    output reg [31:0] addr,
    output reg        write_en,
    output reg [31:0] write_data,
    output reg        led_sign,
    output reg [7:0]  led_data,
    output reg [7:0]  seg_en,
    output reg [7:0]  seg_left,
    output reg [7:0]  seg_right,
    
    output [1:0]  test_state,
    output [31:0] test_cnt
    );
    
    parameter TIME = 100;
    parameter BASE = 0;
    parameter IDLE = 2'b00;
    parameter PEND = 2'b01;
    parameter WORK = 2'b10;
    parameter DONE = 2'b11;
    
    integer cnt;
    reg [1:0] state;
    
    assign test_state = state;
    assign test_cnt = cnt;
    
    always @(posedge clk, posedge rst)
        if (rst) begin
            led_sign = 0;
            led_data = 0;
            seg_en = 8'b1111_1111;
            seg_left = 8'b1111_1111;
            seg_right = 8'b1111_1111;
            cnt <= 0;
            req <= 0;
            write_en <= 0;
            state <= IDLE;
        end
        else
            case(state)
                IDLE: begin
                    if (cnt == TIME) begin
                        req <= 1;
                        state <= PEND;
                    end
                    else cnt <= cnt+1;
                end
                PEND: begin
                    if (io_en) begin
                        addr <= BASE;
                        write_en <= 1;
                        write_data <= state_switch;
                        state <= WORK;
                    end
                end
                WORK: begin
                    case(cnt)
                        TIME: write_data <= data_switch;
                        TIME+1: write_data <= keyboard;
                        TIME+2: begin
                            write_en <= 0;
                            led_sign <= mem_out[0];
                        end
                        TIME+3: led_data <= mem_out[7:0];
                        TIME+4: seg_en <= mem_out[7:0];
                        TIME+5: seg_left <= mem_out[7:0];
                        TIME+6: begin
                            seg_right <= mem_out[7:0];
                            req <= 0;
                            state <= DONE;
                        end
                    endcase
                    cnt <= cnt+1;
                    addr <= addr+4;
                end
                DONE:
                    if (!io_en) begin
                        cnt <= 0;
                        state <= IDLE;
                    end 
            endcase
endmodule