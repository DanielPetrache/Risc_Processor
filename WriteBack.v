`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.01.2021 14:01:21
// Design Name: 
// Module Name: WriteBack
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


module WriteBack(
    input wire [31:0] data_in,
    input wire [41:0] exec_out,
    output reg we,
    output reg [2:0] dest,
    output reg [31:0] result
    );

reg read_memory;
    
always @(*)
begin
    read_memory = exec_out[1:1]; 
    we = exec_out[0:0];
    dest = exec_out[36:34]; 
    if (read_memory == 1) begin
        result = data_in;
    end
    else begin
        result = exec_out[34:2];
    end
end    
endmodule
