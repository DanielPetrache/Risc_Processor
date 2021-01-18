`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.01.2021 15:37:32
// Design Name: 
// Module Name: MUX_DataDependency
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


module MUX_DataDependency(
    input wire [3:0] MuxCtrl,
    input wire [31:0] exec_operand,
    input wire [31:0] load_data,
    input wire [31:0] exec_operand_fast,
    output reg [33:0] MuxData
    );
    
always @(*)
begin
    case (MuxCtrl)
        4'b0101, 4'b0111 : MuxData = {2'b01,load_data};
        4'b0110, 4'b1000 : MuxData = {2'b10,load_data};
        4'b0011 : MuxData = {2'b01,exec_operand};
        4'b0100 : MuxData = {2'b10,exec_operand};
        4'b0001 : MuxData = {2'b01,exec_operand_fast};
        4'b0010 : MuxData = {2'b10,exec_operand_fast};
        default : MuxData = 0;
    endcase
end    
endmodule
