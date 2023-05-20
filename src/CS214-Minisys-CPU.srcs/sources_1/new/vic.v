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

module vic(
    input clk,
    input vic_clk,
    input rst,
    input is_eret,
    input [7:0] source,
    input [31:0] ret_addr,
    output reg vic_enable,
    output reg [31:0] handler_addr,
    output reg [31:0] epc,
    output [3:0] cause
    );
    
    reg interrupt_enable;
    reg [7:0] pending_interrupt;
    reg [3:0] current_interrupt;
    reg [31:0] epc_all [7:0];
    wire [3:0] interrupt;
    assign cause = current_interrupt;
    
    interrupt_encoder ie(
        .source(pending_interrupt),
        .cause(interrupt)
    );
    
    // update need jump and next_pc
    always @(negedge vic_clk) begin
        if (interrupt_enable && current_interrupt) begin
            if (clk) begin
                if (is_eret) begin
                    interrupt_enable <= 0;
                end
                else begin
                    if (current_interrupt) begin
                        vic_enable <= 1;
                        handler_addr <= (current_interrupt << 2) + HANDLER_BASE;
                        current_interrupt <= 0;
                    end
                end
            end
        end
    end
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            interrupt_enable <= 0;
            pending_interrupt <= 8'h00;
            current_interrupt <= 8'h00;
        end
        else begin
            pending_interrupt = pending_interrupt | source;
            vic_enable <= 0;
            if (pending_interrupt && !interrupt_enable) begin
                interrupt_enable <= 1;
                epc_all[interrupt - 1] <= ret_addr;
                epc <= ret_addr;
                current_interrupt <= interrupt;
            end
        end
    end
    
endmodule
