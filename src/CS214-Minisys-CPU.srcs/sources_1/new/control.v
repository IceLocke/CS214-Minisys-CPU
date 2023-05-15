`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: kl
// 
// Create Date: 2023/05/10 09:26:33
// Design Name: 
// Module Name: control
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


module control(
    input [5:0]	opcode,
    input [5:0] funct,  // special case for jr
    output reg_dst,
    output branch,
    output mem_read,
    output mem_to_reg,
    output [5:0] alu_op,
    output mem_write,
    output alu_src,
    output is_jr,
    output reg_write,
    output alu_en,
    output is_R_type,
    output is_J_type,
    output is_I_type,
    output extension_mode  // 1 = sign extension, 0 = 0-extension
);
    assign is_R_type = opcode == 6'b0;
    assign is_J_type = opcode == 6'b10 || opcode == 6'b11;
    assign is_I_type = is_R_type == 0 && is_J_type == 0;
    
    assign reg_dst = is_R_type;
    assign branch = is_J_type || opcode == 6'h4 || opcode == 6'h5;  // J type, beq, bne; NOT contain jr
    assign mem_read = opcode == 6'h23; // lw
    assign mem_to_reg = opcode == 6'h23;
    assign alu_op = opcode; 
    assign mem_write = opcode == 6'h2b; // sw
    assign alu_src = !is_R_type;
    assign is_jr = is_R_type && funct == 6'h8;
    assign reg_write = (is_R_type && !is_jr) || (is_I_type && !branch && !mem_write);
    assign extension_mode = (opcode == 6'h4  // beq
                            || opcode == 6'h5  // bne
                            || opcode == 6'h23  // lw
                            || opcode == 6'h2b  // sw
                            || opcode == 6'h8  // addi
                            || opcode == 6'ha);  // slti
endmodule
