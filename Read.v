`timescale 1ns / 1ps

`include "macros.vh"

module Read(
    input wire [15:0] instruction,
    output reg [7:0] src,
    output reg [18:0] data
    );

reg [1:0] prefix;
reg [4:0] opcode;
reg [2:0] addr;
reg [7:0] val;
reg [2:0] cond;

always @(*)
begin
    prefix = 0;
    opcode = 0;
    addr = 0;
    cond = 0;
    val = 0;
    src = 0;
    prefix = instruction[15:14];
    case (prefix)
        `ALU:
            begin
                opcode = instruction[13:9];
                addr = instruction[8:6];
                case (opcode)
                    `SHIFTR, `SHIFTRA, `SHIFTL :
                        begin
                            src[7:6] = 2'b01;
                            src[5:3] = instruction[8:6];
                            val = {2'b0, instruction[5:0]};
                        end
                    default:
                        begin
                            src[7:6] = 2'b10;
                            src[5:3] = instruction[5:3];
                            src[2:0] = instruction[2:0];
                        end
                endcase
            end
        `LDST:
            begin
                addr = instruction[10:8];
                case (instruction[13:11])
                    `LOAD:
                        begin
                            //src[7:6] = 2'b01;
                            //src[5:3] = instruction[2:0];
                            opcode = 5'b10000;
                        end
                    `LOADC:
                        begin
                            src[7:6] = 2'b01;
                            src[5:3] = instruction[10:8];
                            opcode = 5'b10001;
                            val = instruction[7:0];
                        end
                    `STORE:
                        begin
                            src[7:6] = 2'b10;
                            src[5:3] = instruction[10:8];
                            src[2:0] = instruction[2:0];
                            opcode = 5'b10010;
                        end
                endcase
            end
        `JUMP:
            begin
                case (instruction[13:12])
                    `JMP:
                        begin
                            src[7:6] = 2'b01;
                            src[5:3] = instruction[2:0];
                            opcode = 5'b10011;
                            val = {2'b0, instruction[5:0]};
                        end
                    `JMPR : opcode = 5'b10100;
                    `JMP_cond1:
                        begin
                            src[7:6] = 2'b10;
                            src[5:3] = instruction[8:6];
                            src[2:0] = instruction[2:0];
                            opcode = 5'b10101;
                            cond = instruction[11:9];
                        end
                    `JMP_cond2:
                        begin
                            src[7:6] = 2'b01;
                            src[5:3] = instruction[8:6];
                            opcode = 5'b10110;
                            cond = instruction[11:9];
                            val = {2'b0, instruction[5:0]};
                        end
                endcase
            end
        `NPHLT: 
            begin
                case(instruction[13:9])
                    `NOP : opcode = `NOP;
                    `HALT : opcode = `HALT;
                endcase
            end
    endcase
    data = {opcode, addr, cond, val};
end
endmodule