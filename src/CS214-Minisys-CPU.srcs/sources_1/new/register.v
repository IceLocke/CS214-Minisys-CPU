`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: kl
// 
// Create Date: 2023/05/10 23:02:00
// Design Name: 
// Module Name: register
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


module register(
    input           clk,
    input           rst,
    input [4:0]     read_register_1,
    input [4:0]     read_register_2,
    input [4:0]     write_register,
    input [31:0]    write_data,
    input           reg_write,
    output [31:0]   read_data_1,
    output [31:0]   read_data_2
);
    
    reg [31:0] registers[31:0];
    assign read_data_1 = registers[read_register_1];
    assign read_data_2 = registers[read_register_2];
    parameter frame_pointer = 32'b0;
    integer i;
    
    always @(negedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= (i == 29 ? frame_pointer : 32'b0);
            end
        end else if(reg_write) begin
            if (write_register != 5'b0)
                registers[write_register] = write_data;
        end
    end
    
endmodule
