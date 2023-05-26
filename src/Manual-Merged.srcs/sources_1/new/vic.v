`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/16 18:07:28
// Design Name: 
// Module Name: vic
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


module vic(
    input clk,
    input vic_clk,
    input rst,
    input is_eret,
    input [7:0] source,
    input [31:0] ret_addr,
    output vic_enable,
    output [31:0] handler_addr,
    output reg [31:0] epc,
    output [3:0] cause
    );
    
    parameter HANDLER_BASE = 16'h4000;
    parameter IDLE = 2'b00;
    parameter WAIT = 2'b01;
    parameter PEND = 2'b10;
    parameter DEAL = 2'b11;
    
    reg [1:0] state;
    reg [1:0] next_state;
    reg [7:0] pending_interrupt;
    reg [3:0] current_interrupt;
    reg [31:0] epc_all [7:0];
    wire [3:0] interrupt;
    wire [31:0] handler_offset;
    assign handler_offset = ({{28{1'b0}},interrupt} - 1) << 2;
    assign cause = current_interrupt;
    assign handler_addr = HANDLER_BASE + handler_offset;
    
    interrupt_encoder ie(
        .source(pending_interrupt),
        .interrupt(interrupt)
    );
    
    always @(*) begin
        case (state)
            IDLE: begin
                if ((source || pending_interrupt))
                    next_state = WAIT;
                else next_state = IDLE;
            end
            WAIT: next_state = DEAL;
            DEAL: begin
                if (is_eret)
                    next_state = IDLE;
                else next_state = DEAL;
            end
            default: next_state = IDLE;
        endcase
    end
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pending_interrupt <= 0;
        end
        else begin
            if (state == DEAL)
                pending_interrupt <=
                    ((pending_interrupt | source) & (1<<current_interrupt-1)) ^ 
                    (pending_interrupt | source);
            else
                pending_interrupt <= (pending_interrupt | source);
        end
    end
    
    assign vic_enable = (state == WAIT);
    
    always @(negedge vic_clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            current_interrupt <= 0;
            epc <= 0;
        end
        else begin
            if(clk) begin
                state <= next_state;
                case (state)
                    WAIT: begin
                        current_interrupt <= interrupt;
                        epc_all[interrupt-1] <= ret_addr;
                    end
                    DEAL: epc <= epc_all[current_interrupt-1];
                    IDLE: begin
                        current_interrupt <= 0;
                    end
                endcase
            end
        end
    end
    
endmodule