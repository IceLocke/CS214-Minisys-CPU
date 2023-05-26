module instruction_fetch(
    input clk,
    input uart_clk,
    input rst,
    input branch_inst,
    input jr_inst,
    input jump_inst,
    input vic_enable,
    input eret_inst,
    input io_en,
    input uart_en,
    input uart_wen,
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
    output reg [31:0] ra
    );
    
    wire [31:0] inst;
    wire [31:0] imem_inst;
    reg [31:0] pc;
    reg [31:0] next_pc;
    wire [31:0] pc_plus4;
    wire [31:0] jump_addr;
    
    assign pc_plus4 = pc + 4;
    
    instruction_memory im(
        .clk(clk),
        .uart_clk(uart_clk),
        .addr(pc),
        .uart_en(uart_en),
        .uart_wen(uart_wen),
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
    assign immediate = inst[15:0];
    assign funct = inst[5:0];
    
    assign jump_addr = inst[25:0];
    
    wire [31:0] extended_immediate = {{16{immediate[15]}}, immediate[15:0]};
    
    always @(*) begin
        casez ({uart_en, io_en, jump_inst, branch_inst, jr_inst, eret_inst})
            6'b1?????: next_pc = 32'h00000000;
            6'b01????: next_pc = pc;
            6'b001???: next_pc = {{6{1'b0}}, jump_addr} << 2;
            6'b0001??: next_pc = (extended_immediate << 2) + pc_plus4;
            6'b00001?: next_pc = reg_addr;
            6'b000001: next_pc = epc;
            6'b000000: next_pc = pc_plus4;
            default: next_pc = pc_plus4;
        endcase
    end
    
    always @(negedge clk or posedge rst) begin
        if (rst) begin
            pc <= 0;
            ra <= 0;
        end
        else begin
            pc <= vic_enable ? handler_addr : next_pc;
            ra <= vic_enable ? next_pc : pc_plus4;
        end
    end
    
endmodule