`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.01.2021 08:51:21
// Design Name: 
// Module Name: Execute
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

module Execute(
    input wire [18:0] instruction,
    input wire [63:0] operands_in,
    output reg [9:0] addr,
    output reg update_pc,
    output reg [31:0] pc_new,
    output reg [31:0] data_out,
    output reg [41:0] exec_out,
    output reg [31:0] exec_operand_fast
    );

reg [31:0] result;
reg [7:0] val;
reg [2:0] cond;
reg [2:0] dest;
reg read_memory;
reg write_enable;
reg [4:0] opcode;
reg [31:0] operand1;
reg [31:0] operand2;

always @(*)
begin
    read_memory = 0;
    write_enable = 0;
    update_pc = 0;
    val = 0;
    cond = 0;
    opcode = instruction[18:14];
    result = 0;
    dest = 0;
    operand1 = operands_in[63:32];
    operand2 = operands_in[31:0];
    pc_new = 0;
    case(opcode)
        `ADD : 
            begin 
                result = operand1 + operand2;
                dest = instruction[13:11];
                write_enable = 1;
            end
        `ADDF : 
            begin 
                result = operand1 + operand2;
                dest = instruction[13:11];
                write_enable = 1;
            end
        `SUB : 
            begin
                result = operand1 - operand2;
                dest = instruction[13:11];
                write_enable = 1;
            end
        `SUBF : 
            begin
                result = operand1 - operand2;
                dest = instruction[13:11];
                write_enable = 1;
            end
        `AND : 
            begin
                result = operand1 & operand2;
                dest = instruction[13:11];
                write_enable = 1;
            end
        `OR : 
            begin
                result = operand1 | operand2;
                dest = instruction[13:11];
                write_enable = 1;
            end
        `XOR : 
            begin
                result = operand1 ^ operand2;
                dest = instruction[13:11];
                write_enable = 1;
            end
        `NAND : 
            begin
                result = ~(operand1 & operand2);
                dest = instruction[13:11];
                write_enable = 1;
            end
        `NOR : 
            begin
                result = ~(operand1 | operand2);
                dest = instruction[13:11];
                write_enable = 1;
            end
        `NXOR : 
            begin
                result = ~(operand1 ^ operand2);
                dest = instruction[13:11];
                write_enable = 1;
            end
        `SHIFTR : 
            begin
                result = operand1 >> val;
                dest = instruction[13:11];
                write_enable = 1;
            end
        `SHIFTRA : 
            begin
                result = operand1 >> val;
                dest = instruction[13:11];
                write_enable = 1;
            end
        `SHIFTL : 
            begin
                result = operand1 << val;
                dest = instruction[13:11];
                write_enable = 1;
            end
        `LOADv2 : 
            begin
                dest = instruction[13:11];
                read_memory = 1;
                write_enable = 1;
            end
        `LOADCv2 : 
            begin
                result = {operand1[31:8],val};
                dest = instruction[10:8];
                write_enable = 1;
            end
        `STOREv2 : 
            begin
                addr = operand1;
                data_out = operand2;
            end
        `JMPv2 : 
            begin
                update_pc = 1;
                pc_new = operand1;
            end
        `JMPRv2 :
            begin
                update_pc = 1;
                pc_new = operand1 + val;
            end
        `JMP_cond1v2 : 
            begin
                cond = instruction[10:8];
                case (cond)
                    `cond1 : if (operand1 < 0) begin
                                update_pc = 1;
                                pc_new = operand2;   
                             end
                    `cond2 : if (operand1 >= 0) begin
                                update_pc = 1;
                                pc_new = operand2;   
                             end
                    `cond3 : if (operand1 == 0) begin
                                update_pc = 1;
                                pc_new = operand2;   
                             end
                    `cond4 : if (operand1 != 0) begin
                                update_pc = 1;
                                pc_new = operand2;   
                             end
                endcase
            end
        `JMP_cond2v2 :
            begin
                cond = instruction[10:8];
                val = instruction[5:0];
                case (cond)
                    `cond1 : if (operand1 < 0) begin
                                update_pc = 1;
                                pc_new = pc_new + val;   
                             end
                    `cond2 : if (operand1 >= 0) begin
                                update_pc = 1;
                                pc_new = pc_new + val;   
                             end
                    `cond3 : if (operand1 == 0) begin
                                update_pc = 1;
                                pc_new = pc_new + val;   
                             end
                    `cond4 : if (operand1 != 0) begin
                                update_pc = 1;
                                pc_new = pc_new + val;   
                             end
                endcase
            end
        `NOP : ;
        `HALT : ; 
    endcase
    exec_out = {opcode, dest, result, read_memory, write_enable};
    exec_operand_fast = result;
end    
endmodule
