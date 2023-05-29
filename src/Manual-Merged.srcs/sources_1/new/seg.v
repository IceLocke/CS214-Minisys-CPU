`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: ckr
// 
// Create Date: 2023/05/20 14:16:15
// Design Name: 
// Module Name: seg
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


module seg(
    input clk,
    input rst,
    input [31:0] data,
    
    output reg [7:0] en,
    output reg [7:0] out
    );
    
    parameter TIME = 10000;
    
    integer cnt;
    reg [3:0] digit;
    
    always @(digit)
        case (digit)
            4'h0: out <= 8'b0000_0011;
            4'h1: out <= 8'b1001_1111;
            4'h2: out <= 8'b0010_0101;
            4'h3: out <= 8'b0000_1101;
            4'h4: out <= 8'b1001_1001;
            4'h5: out <= 8'b0100_1001;
            4'h6: out <= 8'b0100_0001;
            4'h7: out <= 8'b0001_1111;
            4'h8: out <= 8'b0000_0001;
            4'h9: out <= 8'b0001_1001;
            default: out <= 8'b1111_1111;
        endcase
        
    integer clk_cnt;
    reg seg_clk;
    
    always @(posedge clk, posedge rst)
        if (rst) begin
            clk_cnt <= 0;
            seg_clk <= 0;
        end else if (clk_cnt == TIME) begin
            clk_cnt <= 1;
            seg_clk <= ~seg_clk;
        end else begin
            clk_cnt <= clk_cnt + 1;
            seg_clk <= seg_clk;
        end
    
    always @(posedge seg_clk, posedge rst)
        if (rst) begin
            digit <= 0;
            en <= 8'b1111_1110;
        end else begin
            // show each digit sequentially
            case (en)
                8'b1111_1110: begin
                    digit <= data/10%10;
                    en <= 8'b1111_1101;
                end
                8'b1111_1101: begin
                    digit <= data/100%10;
                    en <= 8'b1111_1011;
                end
                8'b1111_1011: begin
                    digit <= data/1000%10;
                    en <= 8'b1111_0111;
                end
                8'b1111_0111: begin
                    digit <= data/10000%10;
                    en <= 8'b1110_1111;
                end
                8'b1110_1111: begin
                    digit <= data/100000%10;
                    en <= 8'b1101_1111;
                end
                8'b1101_1111: begin
                    digit <= data/1000000%10;
                    en <= 8'b1011_1111;
                end
                8'b1011_1111: begin
                    digit <= data/10000000%10;
                    en <= 8'b0111_1111;
                end
                8'b0111_1111: begin
                    digit <= data%10;
                    en <= 8'b1111_1110;
                end
                default: begin
                    digit <= data%10;
                    en <= 8'b1111_1110;
                end
            endcase
        end

endmodule
