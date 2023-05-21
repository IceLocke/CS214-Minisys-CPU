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

parameter HANDLER_BASE = 16'hcfff;
parameter IDLE = 2'b00;
parameter WAIT = 2'b01;
parameter DEAL = 2'b10;

module vic(
    input clk,
    input vic_clk,
    input rst,
    input is_eret,
    input [7:0] source,
    input [31:0] ret_addr,
    output vic_enable,
    output reg [31:0] handler_addr,
    output reg [31:0] epc,
    output [3:0] cause
    );
    
    reg [1:0] state;
    reg [1:0] next_state;
    reg [7:0] pending_interrupt;
    reg [3:0] current_interrupt;
    reg [31:0] epc_all [7:0];
    wire [3:0] interrupt;
    assign cause = current_interrupt;
    
    interrupt_encoder ie(
        .source(pending_interrupt),
        .interrupt(cause)
    );
    
    always @(*) begin
        case (state)
            IDLE: begin
                if (source) begin
                    next_state = WAIT;
                end
            end
            WAIT: begin
                next_state = DEAL;
            end
            DEAL: begin
                if (is_eret) begin
                    next_state = IDLE;
                end
                else begin
                    next_state = DEAL;
                end
            end
            default: next_state = IDLE;
        endcase
    end
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pending_interrupt <= 0;
        end
        else pending_interrupt <= pending_interrupt | source;
    end
    
    assign vic_enable = (state == WAIT);
    
    always @(negedge vic_clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            current_interrupt <= 0;
            handler_addr <= HANDLER_BASE;
        end
        else begin
            state <= next_state;
            case (state)
                WAIT: begin
                    current_interrupt <= interrupt;
                    epc_all[interrupt] <= ret_addr;
                    handler_addr <= HANDLER_BASE + 4 * interrupt;
                end
                DEAL: begin
                    epc <= epc_all[current_interrupt];
                end
            endcase
        end
    end
    
endmodule
