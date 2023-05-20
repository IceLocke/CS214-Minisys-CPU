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
    input [5:0] funct,
    output reg_dst,
    output mem_read,
    output mem_to_reg,
    output [5:0] alu_op,
    output mem_write,
    output alu_src,
    output is_j,
    output is_jr,
    output is_jal,
    output is_eret,
    output is_beq_bne,
    output reg_write,
    output alu_en,
    output is_R_type,
    output is_J_type,
    output is_I_type,
    output extension_mode,  // 1 = sign extension, 0 = 0-extension
    output [1:0] reg_read_spe,
    output reg_write_spe
);
    assign is_eret = opcode == 6'h10;
    assign is_R_type = opcode == 6'b0;
    assign is_J_type = opcode == 6'h2 || opcode == 6'h3;
    assign is_I_type = !is_R_type && !is_J_type && !is_eret;
    assign alu_op = opcode;
    assign reg_dst = is_R_type;
    assign mem_read = opcode == 6'h23; // lw
    assign mem_to_reg = opcode == 6'h23;
    assign mem_write = opcode == 6'h2b; // sw
    assign alu_src = !is_R_type;
    assign is_j = is_J_type && opcode == 6'h2;
    assign is_jr = is_R_type && funct == 6'h8;
    assign is_jal = is_J_type && opcode == 6'h3;
    assign is_beq_bne = opcode == 6'h4 || opcode == 6'h5;  // beq, bne
    assign reg_write = (is_R_type && !is_jr) 
                    || (is_I_type && !is_beq_bne && !mem_write);
    assign extension_mode = (is_beq_bne // bne, beq
                         || opcode == 6'h23  // lw
                         || opcode == 6'h2b  // sw
                         || opcode == 6'h8  // addi
                         || opcode == 6'ha);  // slti
    assign alu_en = !is_J_type && !is_eret;
    assign reg_read_spe = (is_R_type && funct == 6'h12) ? 2'b10 :  // mflo
                    ((is_R_type && funct == 6'h10) ? 2'b11 : 2'b00); // mfhi
    assign reg_write_spe = is_R_type && (funct == 6'h1a  // div
                                    || funct == 6'h1b  // divu
                                    || funct == 6'h18  // mult
                                    || funct == 6'h19);  // multu
endmodule
