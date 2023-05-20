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
    input        pos,
    input        neg,
    input [2:0]  state_switch,
    input [7:0]	 data_switch,
    input [9:0]  kb,
    input [31:0] mem_out,
    
    output reg        io_en,
    output reg [31:0] addr,
    output reg        write_en,
    output reg [31:0] write_data,
    output reg        led_sign,
    output reg [7:0]  led_data,
    output reg [31:0] seg_data
    );
    
    parameter TIME = 1000;
    parameter BASE = 0;
    parameter IDLE = 1'b0;
    parameter WORK = 1'b1;
    

    wire kb_done;
    wire [31:0] kb_value;
    wire [11:0] stable;

    stabilizer sb(
        .clk(kb_clk),
        .rst(rst),
        .kb({pos, neg, kb}),
        .stable(stable)
    );

    keyboard keyboard_instance(
        .clk(clk),
        .rst(rst),
        .pos(stable[11]),
        .neg(stable[10]),
        .kb(stable[9:0]),
        .kb_done(kb_done),
        .value(kb_value)
    );

    integer cnt;
    reg state;
    
    always @(posedge clk, posedge rst)
        if (rst) begin
            led_sign = 1'b0;
            led_data = 8'b0000_0000;
            seg_data = 8'b0000_0000;
            cnt <= 0;
            io_en <= 1'b0;
            write_en <= 1'b0;
            state <= IDLE;
        end
        else
            case (state)
                IDLE:
                    if (cnt == TIME) begin
                        state <= WORK;
                        addr <= BASE;
                        write_en <= 1'b1;
                        write_data <= state_switch;
                        state <= WORK;
                    end
                    else cnt <= cnt+1;
                WORK: begin
                    case (cnt)
                        TIME: write_data <= data_switch;
                        TIME+1: write_data <= kb_done;
                        TIME+2: write_data <= kb_value;
                        TIME+3: begin
                            write_en <= 1'b0;
                            led_sign <= mem_out[0];
                        end
                        TIME+4: led_data <= mem_out[7:0];
                        TIME+5: begin
                            seg_data <= mem_out;
                            io_en <= 1'b0;
                            state <= IDLE;
                        end
                    endcase
                    cnt <= (cnt == TIME+4 ? 0 : cnt+1);
                    addr <= addr+4;
                end
                default: state <= state;
            endcase
        
endmodule