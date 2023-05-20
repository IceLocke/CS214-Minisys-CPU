module instruction_fetch(
    input clk,
    input rst,
    input branch_inst,
    input jr_inst,
    input jump_inst,
    input vic_enable,
    input eret_inst,
    input io_en,
    input uart_en,
    input [13:0] uart_addr,
    input [31:0] uart_data,
    input [31:0] handler_addr,
    input [31:0] epc,
    input [31:0] reg_addr,
    output [5:0] opcode,
    output [4:0] rs,
    output [4:0] rt,
    output [4:0] rd,
    output [4:0] shamt,
    output [5:0] funct,
    output [15:0] immediate,
    output [31:0] instruction,
    output [31:0] ra
    );
    
    wire [31:0] inst;
    wire [31:0] imem_inst;
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
        .out(imem_inst)
    );
    
    assign inst = io_en ? 32'h00000000 : imem_inst;
    assign instruction = inst;
    
    assign opcode = inst[31:26];
    assign rs = inst[25:21];
    assign rt = inst[20:16];
    assign rd = inst[15:11];
    assign shamt = inst[10:6];
    assign funct = inst[5:0];
    
    assign jump_addr = inst[25:0];
    
    always @(*) begin
        casez ({uart_en, io_en, vic_enable, jump_inst, branch_inst, jr_inst, eret_inst})
            7'b1??????: next_pc = pc;
            7'b01?????: next_pc = pc;
            7'b001????: next_pc = handler_addr;
            7'b0001???: next_pc = jump_addr;
            7'b00001??: next_pc = immediate * 4 + pc_plus4;
            7'b000001?: next_pc = reg_addr;
            7'b0000001: next_pc = epc;
            7'b0000000: next_pc = pc_plus4;
            default: next_pc = pc_plus4;
        endcase
    end
    
    always @(negedge clk or posedge rst) begin
        if (!rst) begin
            pc <= next_pc;
        end
        else begin
            pc <= 0;
        end
    end
    
endmodule