`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.01.2021 16:46:01
// Design Name: 
// Module Name: DataDependencyDetection
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

module DataDependencyDetection(
    input wire [15:0] dataR1,
    input wire [7:0] dataR2,
    input wire [7:0] dataR3,
    input wire update_pc,
    output reg freeze,
    output reg [3:0] MuxCtrl
    );
    
reg marker;    
always @(*)
begin
    //read after write dependency
    marker = 0;
    freeze = 0;
    MuxCtrl = 0;
    if (((dataR2[7:3] == `JMPv2) | (dataR2[7:3] == `JMPRv2) | (dataR2[7:3] == `JMP_cond1v2) | (dataR2[7:3] == `JMP_cond2v2)) & (update_pc == 1)) begin
        
    end
    else begin
        case (dataR1[15:14])
            `ALU :
                begin
                    case (dataR1[13:9])
                        `SHIFTR, `SHIFTRA, `SHIFTL :
                            begin 
                                if (dataR1[8:6] == dataR2[2:0]) begin
                                    if (dataR2[7:3] == `LOADv2) begin
                                        freeze = 1;
                                        MuxCtrl = 4'b0101; //LOAD, operand1, I2,I1
                                    end
                                    else if (dataR2[7:3] != `NOP) begin
                                        MuxCtrl = 4'b0001; //RAW, operand1, I2,I1
                                    end
                                end
                                else if (dataR1[8:6] == dataR3[2:0]) begin
                                    if (dataR3[7:3] == `LOADv2) begin
                                        MuxCtrl = 4'b0111; //LOAD, operand1, I2,Ix,I1
                                    end
                                    else if (dataR2[7:3] != `NOP) begin
                                        MuxCtrl = 4'b0011; //RAW, operand1, I2,Ix,I1
                                    end
                                end
                            end
                        default :
                            begin
                                if (dataR1[5:3] == dataR2[2:0]) begin
                                    if (dataR2[7:3] == `LOADv2) begin
                                        freeze = 1;
                                        MuxCtrl = 4'b0101; //LOAD, operand1, I2,I1
                                    end
                                    else if (dataR2[7:3] != `NOP) begin
                                        MuxCtrl = 4'b0001; //RAW, operand1, I2,I1
                                    end
                                end
                                else if (dataR1[2:0] == dataR2[2:0]) begin
                                    if (dataR2[7:3] == `LOADv2) begin
                                        freeze = 1;
                                        MuxCtrl = 4'b0110; //LOAD, operand2, I2,I1
                                    end
                                    else if (dataR2[7:3] != `NOP) begin
                                        MuxCtrl = 4'b0010; //RAW, operand2, I2,I1
                                    end
                                end
                                else if (dataR1[5:3] == dataR3[2:0]) begin
                                    if (dataR3[7:3] == `LOADv2) begin
                                        MuxCtrl = 4'b0111; //Load, operand1, I2,Ix,I1
                                    end
                                    else if (dataR3[7:3] != `NOP) begin
                                        MuxCtrl = 4'b0011; //RAW, operand1, I2,Ix,I1
                                    end
                                end
                                else if (dataR1[2:0] == dataR3[2:0]) begin
                                    if (dataR3[7:3] == `LOADv2) begin
                                        MuxCtrl = 4'b1000; //LOAD, operand2, I2,Ix,I1
                                    end
                                    else if (dataR2[7:3] != `NOP) begin
                                        MuxCtrl = 4'b0100; //RAW, operand2, I2,Ix,I1
                                    end
                                end
                            end
                    endcase
                end
            `LDST :
                begin
                    case (dataR1[13:11])
                        `LOADC : 
                            begin
                                if (dataR1[10:8] == dataR2[2:0]) begin
                                    if (dataR2[7:3] == `LOADv2) begin
                                        freeze = 1;
                                        MuxCtrl = 4'b0101; //LOAD, operand1, I2,I1
                                    end
                                    else begin
                                        MuxCtrl = 4'b0001; //RAW, operand1, I2,I1
                                    end
                                end
                                else if (dataR1[10:8] == dataR3[2:0]) begin
                                    if (dataR3[7:3] == `LOADv2) begin
                                        MuxCtrl = 4'b0111; //LOAD, operand1, I2,Ix,I1
                                    end
                                    else begin
                                        MuxCtrl = 4'b0011; //RAW, operand1, I2,Ix,I1
                                    end
                                end
                            end
                        `STORE : 
                            begin
                                if (dataR1[10:8] == dataR2[2:0]) begin
                                    if (dataR2[7:3] == `LOADv2) begin
                                        freeze = 1;
                                        MuxCtrl = 4'b0101; //LOAD, operand1, I2,I1
                                    end
                                    else begin
                                        MuxCtrl = 4'b0001; //RAW, operand1, I2,I1
                                    end
                                end
                                else if (dataR1[10:8] == dataR3[2:0]) begin
                                    if (dataR3[7:3] == `LOADv2) begin
                                        MuxCtrl = 4'b0111; //LOAD, operand1, I2,Ix,I1
                                    end
                                    else begin
                                        MuxCtrl = 4'b0011; //RAW, operand1, I2,Ix,I1
                                    end
                                end
                                else if (dataR1[2:0] == dataR2[2:0]) begin
                                    if (dataR2[7:3] == `LOADv2) begin
                                        freeze = 1;
                                        MuxCtrl = 4'b0110; //LOAD, operand2, I2,I1
                                    end
                                    else begin
                                        MuxCtrl = 4'b0010; //RAW, operand2, I2,I1
                                    end
                                end
                                else if (dataR1[2:0] == dataR3[2:0]) begin
                                    if (dataR3[7:3] == `LOADv2) begin
                                        MuxCtrl = 4'b1000; //LOAD, operand2, I2,Ix,I1
                                    end
                                    else begin
                                        MuxCtrl = 4'b0100; //RAW, operand2, I2,Ix,I1
                                    end
                                end
                            end
                    endcase
                end
            `JUMP :
                begin
                    case (dataR1[13:12])
                        `JMP :
                            begin
                                if (dataR1[2:0] == dataR2[2:0]) begin
                                    if (dataR2[7:3] == `LOADv2) begin
                                        freeze = 1;
                                        MuxCtrl = 4'b0101; //LOAD, operand1, I2,I1
                                    end
                                    else begin
                                        MuxCtrl = 4'b0001; //RAW, operand1, I2,I1
                                    end
                                end
                                else if (dataR1[2:0] == dataR3[2:0]) begin
                                    if (dataR3[7:3] == `LOADv2) begin
                                        MuxCtrl = 4'b0111; //LOAD, operand1, I2,Ix,I1
                                    end
                                    else begin
                                        MuxCtrl = 4'b0011; //RAW, operand1, I2,Ix,I1
                                    end
                                end
                            end
                        `JMP_cond1 : 
                            begin
                                if (dataR1[8:6] == dataR2[2:0]) begin
                                    if (dataR2[7:3] == `LOADv2) begin
                                        freeze = 1;
                                        MuxCtrl = 4'b0101; //LOAD, operand1, I2,I1
                                    end
                                    else begin
                                        MuxCtrl = 4'b0001; //RAW, operand1, I2,I1
                                    end
                                end
                                else if (dataR1[8:6] == dataR3[2:0]) begin
                                    if (dataR3[7:3] == `LOADv2) begin
                                        MuxCtrl = 4'b0111; //LOAD. operand1, I2,Ix,I1
                                    end
                                    else begin
                                        MuxCtrl = 4'b0011; //RAW, operand1, I2,Ix,I1
                                    end
                                end
                                else if (dataR1[2:0] == dataR2[2:0]) begin
                                    if (dataR2[7:3] == `LOADv2) begin
                                        freeze = 1;
                                        MuxCtrl = 4'b0110; //LOAD, operand2, I2,I1
                                    end
                                    else begin
                                        MuxCtrl = 4'b0010; //RAW, operand2, I2,I1
                                    end
                                end
                                else if (dataR1[2:0] == dataR3[2:0]) begin
                                    if (dataR3[7:3] == `LOADv2) begin
                                        MuxCtrl = 4'b1000; //LOAD, operand2, I2,Ix,I1
                                    end
                                    else begin
                                        MuxCtrl = 4'b0100; //RAW, operand2, I2,Ix,I1
                                    end
                                end
                            end
                        `JMP_cond2 :
                            begin
                                if (dataR1[8:6] == dataR2[2:0]) begin
                                    if (dataR2[7:3] == `LOADv2) begin
                                        MuxCtrl = 4'b0101; //LOAD, operand1, I2,I1
                                        freeze = 1;
                                    end
                                    else begin
                                        MuxCtrl = 4'b0001; //RAW, operand1, I2,I1
                                    end
                                end
                                else if (dataR1[8:6] == dataR3[2:0]) begin
                                    if (dataR3[7:3] == `LOADv2) begin
                                        MuxCtrl = 4'b0111; //LOAD, operand1, I2,Ix,I1
                                    end
                                    else begin
                                        MuxCtrl = 4'b0011; //RAW, operand1, I2,Ix,I1
                                    end
                                end
                            end
                    endcase
                end
        endcase
    end
end
endmodule
