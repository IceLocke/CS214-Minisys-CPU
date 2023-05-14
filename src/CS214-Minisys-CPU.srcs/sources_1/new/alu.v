`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: kl
// 
// Create Date: 2023/05/13 10:13:56
// Design Name: 
// Module Name: alu
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


module alu(
    input alu_en,
    input is_I_type,
    input is_R_type,
    input [31:0] num1,
    input [31:0] num2,
    input [5:0] opcode,
    input [5:0] funct,
    input [4:0] shamt,
    output reg [31:0] result,
    output reg alu_exception
);
    always @(*) begin
        if (alu_en) begin
            if (is_I_type) begin
                case(funct)
                    6'h0: result = num2 << shamt; // sll
                    6'h2: result = num2 >> shamt; // srl
                    6'h3: result = $signed(num2) >>> shamt; // sra
                    6'h4: result = num2 << num1[4:0]; // sllv
                    6'h6: result = num2 >> num1[4:0]; // srlv
                    6'h7: result = $signed(num2) >>> num1[4:0]; // srav
                    6'h20: result = $signed(num1) + $signed(num2); // add
                    6'h21: result = num1 + num2; // addu
                    6'h22: result = $signed(num1) - $signed(num2); // sub
                    6'h23: result = num1 - num2; // subu
                    6'h24: result = num1 & num2; // and
                    6'h25: result = num1 | num2; // or
                    6'h26: result = num1 ^ num2; // xor
                    6'h27: result = ~(num1 | num2); // nor
                    6'h2a: result = $signed(num1) < $signed(num2) ? 1 : 0; // slt
                    6'h2b: result = num1 < num2 ? 1 : 0; // sltu
                    default: result = 0;
                endcase
            end
            if (is_R_type) begin
                case (opcode)
                    6'b00_0100: result = (num1 == num2) ? 1 : 0; // beq
                    6'b00_0101: result = (num1 != num2) ? 1 : 0; // bne
                    6'b00_1000: result = $signed(num1) + $signed(num2); // addi
                    6'b00_1001: result = num1 + num2; // addiu
                    6'b00_1010: result = ($signed(num1) < $signed(num2)) ? 1 : 0; // slti
                    6'b00_1011: result = (num1 < num2) ? 1 : 0; // sltiu
                    6'b00_1100: result = num1 & num2; // andi
                    6'b00_1101: result = num1 | num2; // ori
                    6'b00_1110: result = num1 ^ num2; // xori
                    6'b00_1111: result = {num2, 16'b0}; // lui
                    default: result = 0;
                endcase
            end
        end
    end
endmodule
