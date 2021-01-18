`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.01.2021 08:48:33
// Design Name: 
// Module Name: Fetch
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
`include "macros.vh"

module Fetch(
    input wire clk,
    input wire reset,
    input wire freeze,
    input wire update_pc,
    input wire [15:0] instruction,
    input wire [31:0] pc_new,
    output reg [15:0] data,
    output reg [31:0] pc
    );

initial begin
    pc = 0;
end
    
always @(*)
begin
    data = instruction;
end

always @(posedge clk)
begin
    if (reset == 1) begin
        pc <= 0;
    end
    else begin
        if (freeze == 1) begin
            pc <= pc;
        end
        else begin
            if (update_pc == 1) begin
                pc <= pc_new;
            end
            else begin
                pc <= pc + 1;
            end
        end
    end
end
endmodule
