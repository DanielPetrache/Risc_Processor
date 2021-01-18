`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.01.2021 14:14:28
// Design Name: 
// Module Name: Regs
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


module Regs(
    input wire clk,
    input wire reset,
    input wire we,
    input wire [7:0] src,
    input wire [2:0] dest,
    input wire [31:0] result,
    output reg [63:0] operands
    );
    
reg [31:0] R[7:0];    
integer i;

initial begin
    for (i = 0; i <= 7; i = i + 1) begin
        R[i] <= 0;
    end
end

always @(*)begin
    case (src[7:6])
        2'b01:
            begin
                operands[63:32] <= R[src[5:3]];
                operands[31:0] <= 0;
            end
        2'b10:
            begin
                operands[63:32] <= R[src[5:3]];
                operands[31:0] <= R[src[2:0]];
            end
    endcase
end

always @(posedge clk)
begin
    if (reset == 1) begin
        for (i = 0; i <= 7; i = i + 1) begin
            R[i] <= 0;
        end
    end
    else begin
        if (we == 1) begin
            R[dest] <= result;
        end    
    end
    
end
endmodule
