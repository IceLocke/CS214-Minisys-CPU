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
    input jr_inst,
    input jump_inst,
    input vic_enable,
    input uart_en,
    input [13:0] uart_addr,
    input [31:0] uart_data,
    input [31:0] handler_addr,
    input [31:0] reg_addr,
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
        case ({uart_en, vic_enable, jump_inst, branch_inst, jr_inst})
            5'b1xxxx: next_pc <= next_pc;
            5'b01xxx: next_pc <= handler_addr;
            5'b001xx: next_pc <= jump_addr;
            5'b0001x: next_pc <= immediate * 4 + pc_plus4;
            5'b00001: next_pc <= reg_addr;
            5'b00000: next_pc <= pc_plus4;
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
