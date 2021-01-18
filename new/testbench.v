`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.01.2021 20:35:22
// Design Name: 
// Module Name: testbench
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

module testbench(
    input [15:0] instruction,
    output [31:0] pc,
    output [9:0] addr,
    output [31:0] data_out
);

reg [31:0] data_in;
reg clk;
reg reset;     
Processor TOP(
    .clk(clk),
    .reset(reset),
    .instruction(instruction),
    .data_in(data_in),
    .pc(pc),
    .addr(addr),
    .data_out(data_out)
);

reg [15:0] memory [9:0];
integer i;

initial begin
    clk <= 0;
    reset <= 0;
    data_in <= 8;
    for (i = 0; i < 10; i = i + 1) begin
        memory[i] <= {`NPHLT, `NOP, 9'b0};
    end
    memory[0] <= {`LDST, `LOAD, `R7, 8'b0};
    memory[1] <= {`LDST, `LOAD, `R6, 8'b0};
    memory[2] <= {`LDST, `LOAD, `R5, 8'b0};
    memory[3] <= {`ALU, `ADD, `R4, `R5, `R7};
    memory[4] <= {`LDST, `LOAD, `R0, 8'b0};
    memory[5] <= {`ALU, `SUB, `R2, `R6, `R7};
    memory[6] <= {`ALU, `SUB, `R3, `R4, `R5};
    memory[7] <= {`ALU, `ADD, `R1, `R3, `R7};
    memory[8] <= {`JUMP, `JMP, 9'b0, `R2};
    //memory[3] <= {`ALU, `ADD, `R4, `R7, `R5};
    #35
    data_in <= 10;
    #10
    data_in <= 21;
    #70
    data_in <= 1;
    #190
    $finish;
end
always begin
    #5 clk = ~clk;
end

assign instruction = memory[pc];
endmodule
