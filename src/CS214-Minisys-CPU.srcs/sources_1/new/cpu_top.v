`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: kl
// 
// Create Date: 2023/05/10 16:05:47
// Design Name: 
// Module Name: cpu_top
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


module cpu_top(
    input           clk_in,
    input           rst,
    input [2:0]     state_switch,
    input [7:0]     data_switch,
    input [15:0]    keyboard,
    input           uart_enable,
    input           uart_in,
    output          led_sign,
    output [7:0]    led_data,
    output [7:0]    seg_en,
    output [7:0]    seg_left,
    output [7:0]    seg_right
);
    
    /* clock part */
    wire clk;
    cpu_clk cpu_clk_instance(
        .clk_in(clk_in),
        .clk_out(clk)
    );
    
    /* ISA part */
    wire [31:0] alu_result;
    wire [5:0] opcode;
    wire [4:0] rs;
    wire [4:0] rt;
    wire [4:0] rd;
    wire [4:0] shamt;
    wire [15:0] immediate;
    wire [31:0] ra;
    wire [5:0] funct;
    wire reg_dst;
    wire mem_read;
    wire mem_to_reg;
    wire [5:0] alu_op;
    wire mem_write;
    wire alu_src;
    wire is_j;
    wire is_jr;
    wire is_jal;
    wire is_beq_bne;
    wire reg_write;
    wire alu_en;
    wire is_R_type;
    wire is_J_type;
    wire is_I_type;
    wire extension_mode;
    wire vic_enable;
    wire uart_en;
    wire [13:0] uart_addr;
    wire [31:0] uart_data;
    wire [31:0] handler_addr;
    wire [31:0] reg_read_data_1;
    wire [31:0] reg_read_data_2;
    wire [31:0] sign_extension_output;
    wire alu_exception;
    wire [31:0] mem_read_output;
    wire uart_done;
    instruction_fetch if_instance(
        .clk(clk),
        .rst(rst),
        .branch_inst(alu_result[0] && is_beq_bne),
        .jump_inst(is_j || is_jal),
        .vic_enable(vic_enable),
        .uart_en(uart_en),
        .uart_addr(uart_addr),
        .uart_data(uart_data),
        .handler_addr(handler_addr),
        .opcode(opcode),
        .rs(rs),
        .rt(rt),
        .rd(rd),
        .shamt(shamt),
        .funct(funct),
        .immediate(immediate),
        .ra(ra)
    );
    control control_instance(
        .opcode(opcode),
        .funct(funct),
        .reg_dst(reg_dst),
        .mem_read(mem_read),
        .mem_to_reg(mem_to_reg),
        .alu_op(alu_op),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .is_j(is_j),
        .is_jr(is_jr),
        .is_jal(is_jal),
        .is_beq_bne(is_beq_bne),
        .reg_write(reg_write),
        .alu_en(alu_en),
        .is_R_type(is_R_type),
        .is_J_type(is_J_type),
        .is_I_type(is_I_type),
        .extension_mode(extension_mode)
    );
    register register_instance(
        .clk(clk),
        .rst(rst),
        .read_register_1(rs),
        .read_register_2(reg_dst ? rd : rt),
        .write_register(rd),
        .write_data(
            is_jal ? ra : (
                mem_to_reg ? mem_read_output : alu_result
            )
        ),
        .reg_write(reg_write),
        .read_data_1(reg_read_data_1),
        .read_data_2(reg_read_data_2)
    );
    sign_extension sign_extension_instance(
        .extension_mode(extension_mode),
        .immediate_16(immediate),
        .immediate_32(sign_extension_output)
    );
    alu alu_instance(
        .alu_en(alu_en),
        .is_I_type(is_I_type),
        .is_R_type(is_R_type),
        .num1(reg_read_data_1),
        .num2(alu_src ? sign_extension_output : reg_read_data_2),
        .opcode(opcode),
        .funct(funct),
        .shamt(shamt),
        .result(alu_result),
        .alu_exception(alu_exception)
    );
    data_memory data_memory_instance(
        .clk(clk),
        .uart_clk(clk),
        .write_en(mem_write),
        .read_en(mem_read),
        .uart_en(uart_en),
        .uart_done(uart_done),
        .addr(alu_result),
        .write_data(reg_read_data_2),
        .uart_addr(uart_addr),
        .uart_data(uart_data),
        .out(mem_read_output)
    );
endmodule
