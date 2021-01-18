`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.01.2021 16:28:57
// Design Name: 
// Module Name: Processor
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


module Processor(
    input wire clk,
    input wire reset,
    input wire [15:0] instruction,
    input wire [31:0] data_in,
    output wire [31:0] pc,
    output wire [9:0] addr,
    output wire [31:0] data_out
    );

wire freeze;
wire update_pc;
wire [31:0] pc_new;
wire [15:0] data;    
Fetch F(
    .clk(clk),
    .reset(reset),
    .freeze(freeze),
    .update_pc(update_pc),
    .instruction(instruction),
    .pc_new(pc_new),
    .data(data),
    .pc(pc)
);

wire [15:0] R1_out;
wire [15:0] R1_dep;
PipelineReg #(.bits_in(15), .dep_out(15)) R1(
    .clk(clk),
    .freeze(freeze),
    .update_pc(update_pc),
    .data_in(data),
    .data_out(R1_out),
    .dependency_out(R1_dep)
);

wire [7:0] src;
wire [18:0] Read_out;
Read R(
    .instruction(R1_out),
    .src(src),
    .data(Read_out)
);

wire [18:0] R2_out;
wire [7:0] R2_dep;
wire [63:0] operands_in;
wire [63:0] operands_out;
wire [63:0] operands;
wire [33:0] MuxData;
wire [63:0] new_operand;
PipelineReg #(.bits_in(18), .dep_out(7)) R2(
    .clk(clk),
    .freeze(freeze),
    .update_pc(update_pc),
    .data_in(Read_out),
    .operands_in(operands),
    .MuxData(MuxData),
    .operands_out(operands_out),
    .data_out(R2_out),
    .dependency_out(R2_dep)
);

wire [31:0] memory_data;
wire [41:0] Exec_out;
wire [31:0] exec_operand_fast;
Execute E(
    .instruction(R2_out),
    .operands_in(operands_out),
    .addr(addr),
    .update_pc(update_pc),
    .pc_new(pc_new),
    .data_out(memory_data),
    .exec_out(Exec_out),
    .exec_operand_fast(exec_operand_fast)
);

wire [7:0] R3_dep;
wire [41:0] R3_out;
PipelineReg #(.bits_in(41), .dep_out(7)) R3(
    .clk(clk),
    .data_in(Exec_out),
    .data_out(R3_out),
    .dependency_out(R3_dep),
    .new_operand(new_operand)
);

wire we;
wire [2:0] dest;
wire [31:0] result;
WriteBack WB(
    .data_in(data_in),
    .exec_out(R3_out),
    .we(we),
    .dest(dest),
    .result(result)
);

Regs Regs(
    .clk(clk),
    .reset(reset),
    .we(we),
    .src(src),
    .dest(dest),
    .result(result),
    .operands(operands)
);

wire [3:0] MuxCtrl;
DataDependencyDetection DDD(
    .dataR1(R1_dep),
    .dataR2(R2_dep),
    .dataR3(R3_dep),
    .update_pc(update_pc),
    .freeze(freeze),
    .MuxCtrl(MuxCtrl)
);

MUX_DataDependency MUX(
    .MuxCtrl(MuxCtrl),
    .exec_operand(new_operand),
    .load_data(data_in),
    .exec_operand_fast(exec_operand_fast),
    .MuxData(MuxData)
);
endmodule
