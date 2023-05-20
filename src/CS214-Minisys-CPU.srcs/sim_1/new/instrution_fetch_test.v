`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/20 16:54:25
// Design Name: 
// Module Name: instrution_fetch_test
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


module instrution_fetch_test();

    reg clk, rst;
    reg io_en;
    wire zero;
    assign zero = 0;
    wire [31:0] inst;
    
    instruction_fetch ifetch(
        .clk(clk),
        .rst(rst),
        .branch_inst(zero),
        .jr_inst(zero),
        .jump_inst(zero),
        .vic_enable(zero),
        .eret_inst(zero),
        .io_en(io_en),
        .uart_en(zero),
        .instruction(inst)
    );
    
    always #5 clk = ~clk;
    
    initial begin
        $monitor("initial begin");
        clk = 0;
        io_en = 0;
        rst = 0;
        #5
        rst = 1;
        #5
        rst = 0;
        #10
        io_en = 1;
        #100
        io_en = 0;
    end

endmodule
