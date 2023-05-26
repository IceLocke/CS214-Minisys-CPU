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
    input           ack,
    input           rx,
    input           uart_rst,
    input           uart_en,
    input  [3:0]    col,
    output [3:0]    row,
    output          tx,
    output          led_sign,
    output [7:0]    led_data,
    output [7:0]    seg_en,
    output [7:0]    seg_out
);
    
    /* clock part */
    wire clk_46MHz;
    wire clk_23MHz;
    wire clk_10MHz;
    cpu_clk cpu_clk_instance(
        .rst(rst),
        .clk_in(clk_in),
        .clk_46MHz(clk_46MHz),
        .clk_23MHz(clk_23MHz),
        .clk_10MHz(clk_10MHz)
    );
    
    /* ISA part */
    
    wire [63:0] alu_result;
    wire [5:0] opcode;
    wire [4:0] rs;
    wire [4:0] rt;
    wire [4:0] rd;
    wire [4:0] shamt;
    wire [15:0] immediate;
    wire [31:0] ra;
    wire [5:0] funct;
    wire [7:0] ir_source;
    wire reg_dst;
    wire mem_read;
    wire mem_to_reg;
    wire [5:0] alu_op;
    wire mem_write;
    wire alu_src;
    wire is_j;
    wire is_jr;
    wire is_jal;
    wire is_eret;
    wire is_beq_bne;
    wire reg_write;
    wire alu_en;
    wire is_R_type;
    wire is_J_type;
    wire is_I_type;
    wire extension_mode;
    wire vic_enable;
    wire uart_i;
    wire uart_d;
    wire [13:0] uart_addr;
    wire [31:0] uart_data;
    wire [31:0] handler_addr;
    wire [31:0] reg_read_data_1;
    wire [31:0] reg_read_data_2;
    wire [31:0] sign_extension_output;
    wire alu_exception;
    wire [31:0] mem_read_output;
    wire uart_done;
    wire [1:0] reg_read_spe;
    wire reg_write_spe;
    wire io_en;
    wire [31:0] epc;
    wire [31:0] io_addr;
    wire io_write_en;
    wire [31:0] io_write_data;
    wire [31:0] addr;
    wire write_en;
    wire [31:0] write_data;
    wire [31:0] seg_data;
    wire sys_clk;
    wire uart_wen;
    
    assign ir_source = {1'b0, 1'b0, 1'b0, 1'b0, sys_clk, 1'b0, alu_exception, 1'b0};
    
    instruction_fetch if_instance(
        .clk(clk_23MHz),
        .uart_clk(clk_10MHz),
        .rst(rst),
        .branch_inst(alu_result[0] && is_beq_bne),
        .jr_inst(is_jr),
        .jump_inst(is_j || is_jal),
        .vic_enable(vic_enable),
        .eret_inst(is_eret),
        .io_en(io_en),
        .uart_en(uart_i),
        .uart_wen(uart_wen),
        .uart_addr(uart_addr),
        .uart_data(uart_data),
        .handler_addr(handler_addr),
        .epc(epc),
        .reg_addr(reg_read_data_1),
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
        .is_eret(is_eret),
        .is_beq_bne(is_beq_bne),
        .reg_write(reg_write),
        .alu_en(alu_en),
        .is_R_type(is_R_type),
        .is_J_type(is_J_type),
        .is_I_type(is_I_type),
        .extension_mode(extension_mode),
        .reg_write_spe(reg_write_spe),
        .reg_read_spe(reg_read_spe)
    );
    register register_instance(
        .clk(clk_23MHz),
        .rst(rst),
        .read_register_1(rs),
        .read_register_2(rt),
        .read_spe(reg_read_spe),
        .write_spe(reg_write_spe),
        .write_register(
            is_jal ? 5'b11111 : (
                reg_dst ? rd : rt
            )
        ),
        .write_data(
            is_jal ? ra : (
                reg_read_spe[1] ? reg_read_data_1 : (
                    mem_to_reg ? mem_read_output : alu_result
                )
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
    dma dma_instance(
        .io_en(io_en),
        .cpu_addr(alu_result[31:0]),
        .cpu_write_en(mem_write),
        .cpu_write_data(reg_read_data_2),
        .io_addr(io_addr),
        .io_write_en(io_write_en),
        .io_write_data(io_write_data),
        .addr(addr),
        .write_en(write_en),
        .write_data(write_data)
    );
    data_memory data_memory_instance(
        .clk(clk_23MHz),
        .uart_clk(clk_10MHz),
        .write_en(write_en),
        .addr(addr),
        .write_data(write_data),
        .uart_en(uart_d),
        .uart_wen(uart_wen),
        .uart_addr(uart_addr),
        .uart_data(uart_data),
        .out(mem_read_output)
    );
    uart uart_instance(
        .uart_clk(clk_10MHz),
        .uart_rst(uart_rst),
        .uart_en(uart_en),
        .uart_wen(uart_wen),
        .uart_i(uart_i),
        .uart_d(uart_d),
        .uart_addr(uart_addr),
        .uart_data(uart_data),
        .rx(rx),
        .tx(tx)
    );
    vic vic_instance(
        .clk(clk_23MHz),
        .vic_clk(clk_46MHz),
        .rst(rst),
        .is_eret(is_eret),
        .source(ir_source),
        .ret_addr(ra),
        .vic_enable(vic_enable),
        .handler_addr(handler_addr),
        .epc(epc)
    );
    io io_instance(
        .clk(clk_23MHz),
        .rst(rst),
        .kb_clk(clk_10MHz),
        .state_switch(state_switch),
        .data_switch(data_switch),
        .col(col),
        .row(row),
        .ack(ack),
        .mem_out(mem_read_output),
        .io_en(io_en),
        .addr(io_addr),
        .write_en(io_write_en),
        .write_data(io_write_data),
        .led_sign(led_sign),
        .led_data(led_data),
        .seg_data(seg_data)
    );
    seg seg_instance(
        .clk(clk_10MHz),
        .rst(rst),
        .data(seg_data),
        .en(seg_en),
        .out(seg_out)
    );
    sys_clock sys_clock_instance(
        .clk(~clk_23MHz),
        .rst(rst),
        .sys_clk(sys_clk)
    );
endmodule
