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

    stabilizer sb0(
        .clk(kb_clk),
        .rst(rst),
        .button(kb[0]),
        .stable(stable[0])
    );
    stabilizer sb1(
        .clk(kb_clk),
        .rst(rst),
        .button(kb[1]),
        .stable(stable[1])
    );
    stabilizer sb2(
        .clk(kb_clk),
        .rst(rst),
        .button(kb[2]),
        .stable(stable[2])
    );
    stabilizer sb3(
        .clk(kb_clk),
        .rst(rst),
        .button(kb[3]),
        .stable(stable[3])
    );
    stabilizer sb4(
        .clk(kb_clk),
        .rst(rst),
        .button(kb[4]),
        .stable(stable[4])
    );
    stabilizer sb5(
        .clk(kb_clk),
        .rst(rst),
        .button(kb[5]),
        .stable(stable[5])
    );
    stabilizer sb6(
        .clk(kb_clk),
        .rst(rst),
        .button(kb[6]),
        .stable(stable[6])
    );
    stabilizer sb7(
        .clk(kb_clk),
        .rst(rst),
        .button(kb[7]),
        .stable(stable[7])
    );
    stabilizer sb8(
        .clk(kb_clk),
        .rst(rst),
        .button(kb[8]),
        .stable(stable[8])
    );
    stabilizer sb9(
        .clk(kb_clk),
        .rst(rst),
        .button(kb[9]),
        .stable(stable[9])
    );
    stabilizer sb10(
        .clk(kb_clk),
        .rst(rst),
        .button(pos),
        .stable(stable[10])
    );
    stabilizer sb11(
        .clk(kb_clk),
        .rst(rst),
        .button(neg),
        .stable(stable[11])
    );

    keyboard keyboard_instance(
        .clk(clk),
        .rst(rst),
        .pos(stable[11]),
        .neg(stable[10]),
        .kb(stable[9:0]),
        .kb_done(kb_done),
        .out(kb_value)
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