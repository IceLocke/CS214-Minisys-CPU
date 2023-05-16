`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/16 16:22:14
// Design Name: 
// Module Name: instruction_fetch
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


module instruction_fetch(
    input clk,
    input rst,
    input branch_inst,
    input jump_inst,
    input vic_enable,
    input uart_en,
    input [31:0] uart_addr,
    input [31:0] uart_data,
    input [31:0] hanlder_addr,
    output [5:0] opcode,
    output [4:0] rs,
    output [4:0] rt,
    output [4:0] rd,
    output [4:0] shamt,
    output [5:0] funct,
    output [15:0] immediate,
    output [31:0] ra
    );
    
    reg [31:0] inst;
    reg [31:0] pc;
    reg [31:0] next_pc;
    wire [31:0] pc_plus4;
    wire [31:0] jump_addr;
    
    assign pc_plus4 = pc + 4;
    assign ra = pc_plus4;
    
    instruction_memory im(
        .clk(clk),
        .addr(pc),
        .uart_en(uart_en),
        .uart_addr(uart_addr),
        .uart_data(uart_data),
        .out(inst)
    );
    
    assign opcode = inst[31:26];
    assign rs = inst[25:21];
    assign rt = inst[20:16];
    assign rd = inst[15:11];
    assign shamt = inst[10:6];
    assign funct = inst[5:0];
    
    assign jump_addr = inst[25:0];
    
    always @(*) begin
        case ({uart_en, vic_enable, jump_inst, branch_inst})
            4'b1xxx: next_pc <= next_pc;
            4'b01xx: next_pc <= hanlder_addr;
            4'b001x: next_pc <= jump_addr;
            4'b0001: next_pc <= immediate * 4 + pc_plus4;
            4'b0000: next_pc <= pc_plus4;
        endcase
    end
    
    always @(negedge clk or rst) begin
        if (!rst) begin
            pc <= next_pc;
        end
        else begin
            pc <= 0;
        end
    end
    
endmodule
