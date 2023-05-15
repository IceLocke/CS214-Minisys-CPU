`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: ckr
// 
// Create Date: 2023/05/05 20:31:09
// Design Name: 
// Module Name: dma
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


module dma(
    input         clk,
    input         rst,
    input         io_en,
    input  [31:0] cpu_addr,
    input         cpu_write_en,
    input  [31:0] cpu_write_data,
    input  [31:0] io_addr,
    input         io_write_en,
    input  [31:0] io_write_data,
    
    output reg [31:0] addr,
    output reg        write_en,
    output reg [31:0] write_data,
    output reg [31:0] out
    );
    
    parameter CPU = 1'b0;
    parameter IO  = 1'b1;
    
    reg state;
    
    always @(posedge clk, posedge rst)
        if (rst) begin
            addr <= cpu_addr;
            write_en <= cpu_write_en;
            write_data <= cpu_write_data;
            state <= CPU;
        end
        else begin
            case(state)
                CPU: begin
                    if (io_en) begin
                        addr <= io_addr;
                        write_en <= io_write_en;
                        write_data <= io_write_data;
                        state <= IO;
                    end
                end
                IO: begin
                    if (!io_en) begin
                        addr <= cpu_addr;
                        write_en <= cpu_write_en;
                        write_data <= cpu_write_data;
                        state <= CPU;
                    end
                end
            endcase
        end
    
endmodule
