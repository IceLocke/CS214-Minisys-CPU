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
    input        kb_clk,
    input        ack,
    input [2:0]  state_switch,
    input [7:0]	 data_switch,
    input [31:0] mem_out,
    input [3:0]  col,
    input [31:0] uart_data,
    
    output [3:0] row,
    output reg        io_en,
    output reg [31:0] addr,
    output reg        write_en,
    output reg [31:0] write_data,
    output reg        led_sign,
    output reg [7:0]  led_data,
    output reg [31:0] seg_data
    );
    
    // MMIO refresher
    parameter IDLE = 1'b0;
    parameter WORK = 1'b1;
    parameter TIME = 1000;//20;
    parameter BASE = 32'h4000;

    integer cnt;
    reg state;

    // keyboard buffer
    parameter WAIT = 2'b00;
    parameter INPT = 2'b01;
    parameter DONE = 2'b11;

    wire [15:0] kb_t, kb;
    reg kb_done, kb_req;
    reg [1:0] kb_state;
    reg [15:0] last;
    reg [31:0] buffer;
    reg [31:0] kb_value;

    keyboard keyboard_instance(
        .clk(kb_clk),
        .rst(rst),
        .row(row),
        .col(col),
        .kb(kb_t)
    );

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            buffer <= 0;
            kb_value <= 0;
            kb_done <= 1'b0;
            last <= 16'b0;
            kb_state <= WAIT;
        end
        else if (cnt == 0) begin
            case (kb_state)
                WAIT: begin
                    if (kb_req) begin
                        kb_state <= INPT;
                    end
                end
                INPT: begin
                    if (kb[1] || kb[3] || buffer >= 10000000) begin
                        kb_value <= (kb[1] ? -buffer : buffer);
                        kb_done <= 1'b1;
                        kb_state <= DONE;
                    end
                    else begin
                        if (kb != last) begin
                            case (kb)
                                16'b1000_0000_0000_0000:
                                    buffer <= buffer*10+1;
                                16'b0100_0000_0000_0000:
                                    buffer <= buffer*10+2;
                                16'b0010_0000_0000_0000:
                                    buffer <= buffer*10+3;
                                16'b0000_1000_0000_0000:
                                    buffer <= buffer*10+4;
                                16'b0000_0100_0000_0000:
                                    buffer <= buffer*10+5;
                                16'b0000_0010_0000_0000:
                                    buffer <= buffer*10+6;
                                16'b0000_0000_1000_0000:
                                    buffer <= buffer*10+7;
                                16'b0000_0000_0100_0000:
                                    buffer <= buffer*10+8;
                                16'b0000_0000_0010_0000:
                                    buffer <= buffer*10+9;
                                16'b0000_0000_0000_0100:
                                    buffer <= buffer*10;
                            endcase
                            last <= kb;
                        end
                    end
                end
                DONE: begin
                    kb_done <= 1'b0;
                    kb_state <= WAIT;
                end
                default: begin
                    kb_done <= 1'b0;
                    kb_state <= WAIT;
                end
            endcase
        end
    end

    reg sw_done, sw_req;
    reg [1:0] sw_state;
    reg [8:0] sw_value;
    reg [2:0] state_value;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            state_value <= 0;
            sw_value <= 0;
            sw_done <= 1'b0;
            sw_state <= WAIT;
        end
        else if (cnt == 0) begin
            case (sw_state)
                WAIT: begin
                    if (sw_req)
                        sw_state <= WORK;
                end
                WORK: begin
                    if (ack) begin
                        state_value <= state_switch;
                        sw_value <= data_switch;
                        sw_done <= 1'b1;
                        sw_state <= DONE;
                    end
                end
                DONE: begin
                    sw_done <= 1'b0;
                    sw_state <= WAIT;
                end
                default: begin
                    sw_done <= 1'b0;
                    sw_state <= WAIT;
                end
            endcase
        end
    end

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            led_sign = 1'b0;
            led_data = 8'b0000_0000;
            seg_data = 8'b0000_0000;
            kb_req <= 1'b0;
            sw_req <= 1'b0;
            cnt <= 0;
            io_en <= 1'b0;
            write_en <= 1'b0;
            state <= IDLE;
        end
        else begin
            case (state)
                IDLE: begin
                    if (cnt == TIME) begin
                        io_en <= 1'b1;
                        addr <= BASE;
                        write_en <= 1'b0;
                        state <= WORK;
                    end
                    cnt <= cnt+1;
                end
                WORK: begin
                    case (cnt)
                        TIME+1: begin
                            led_sign <= mem_out[0];
                            addr <= BASE+4;
                        end
                        TIME+2: begin
                            led_data <= mem_out[7:0];
                            addr <= BASE+8;
                        end
                        TIME+3: begin
                            seg_data <= mem_out;
                            addr <= BASE+12;
                        end
                        TIME+4: begin
                            kb_req <= mem_out[0];
                            addr <= BASE+16;
                        end
                        TIME+5: begin
                            sw_req <= mem_out[0];
                            write_en <= 1'b1;
                            write_data <= (kb_state == DONE ? 1'b0 : kb_req);
                            addr <= BASE+12;
                        end
                        TIME+6: begin
                            write_data <= (sw_state == DONE ? 1'b0 : sw_req);
                            addr <= BASE+16;
                        end
                        TIME+7: begin
                            write_data <= kb_done;
                            addr <= BASE+20;
                        end
                        TIME+8: begin
                            write_data <= sw_done;
                            addr <= BASE+24;
                        end
                        TIME+9: begin
                            write_data <= kb_value;
                            addr <= BASE+28;
                        end
                        TIME+10: begin
                            write_data <= sw_value;
                            addr <= BASE+32;
                        end
                        TIME+11: begin
                            write_data <= state_value;
                            addr <= BASE+36;
                        end
                        default: begin
                            write_en <= 1'b0;
                        end
                    endcase
                    if (cnt <= TIME+11) begin
                        cnt <= cnt+1;
                    end
                    else begin
                        cnt <= 0;
                        write_en <=1'b0;
                        io_en <= 1'b0;
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

    stabilizer sb0(
        .clk(kb_clk),
        .rst(rst),
        .button(kb_t[0]),
        .stable(kb[0])
    );
    stabilizer sb1(
        .clk(kb_clk),
        .rst(rst),
        .button(kb_t[1]),
        .stable(kb[1])
    );
    stabilizer sb2(
        .clk(kb_clk),
        .rst(rst),
        .button(kb_t[2]),
        .stable(kb[2])
    );
    stabilizer sb3(
        .clk(kb_clk),
        .rst(rst),
        .button(kb_t[3]),
        .stable(kb[3])
    );
    stabilizer sb4(
        .clk(kb_clk),
        .rst(rst),
        .button(kb_t[4]),
        .stable(kb[4])
    );
    stabilizer sb5(
        .clk(kb_clk),
        .rst(rst),
        .button(kb_t[5]),
        .stable(kb[5])
    );
    stabilizer sb6(
        .clk(kb_clk),
        .rst(rst),
        .button(kb_t[6]),
        .stable(kb[6])
    );
    stabilizer sb7(
        .clk(kb_clk),
        .rst(rst),
        .button(kb_t[7]),
        .stable(kb[7])
    );
    stabilizer sb8(
        .clk(kb_clk),
        .rst(rst),
        .button(kb_t[8]),
        .stable(kb[8])
    );
    stabilizer sb9(
        .clk(kb_clk),
        .rst(rst),
        .button(kb_t[9]),
        .stable(kb[9])
    );
    stabilizer sb10(
        .clk(kb_clk),
        .rst(rst),
        .button(kb_t[10]),
        .stable(kb[10])
    );
    stabilizer sb11(
        .clk(kb_clk),
        .rst(rst),
        .button(kb_t[11]),
        .stable(kb[11])
    );
    stabilizer sb12(
        .clk(kb_clk),
        .rst(rst),
        .button(kb_t[12]),
        .stable(kb[12])
    );
    stabilizer sb13(
        .clk(kb_clk),
        .rst(rst),
        .button(kb_t[13]),
        .stable(kb[13])
    );
    stabilizer sb14(
        .clk(kb_clk),
        .rst(rst),
        .button(kb_t[14]),
        .stable(kb[14])
    );
    stabilizer sb15(
        .clk(kb_clk),
        .rst(rst),
        .button(kb_t[15]),
        .stable(kb[15])
    );

endmodule