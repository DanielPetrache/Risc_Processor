`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.01.2021 10:00:24
// Design Name: 
// Module Name: PipelineReg
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


module PipelineReg#(parameter bits_in = 0, parameter dep_out = 0)(
    input wire clk,
    input wire freeze,
    input wire update_pc,
    input wire [bits_in:0] data_in,
    input wire [63:0] operands_in,
    input wire [33:0] MuxData,
    output reg [63:0] operands_out,
    output reg [bits_in:0] data_out,
    output reg [dep_out:0] dependency_out,
    output reg [31:0] new_operand
    );
    
always @(posedge clk)
begin
    operands_out <= 0;
    case (bits_in)
        15 : 
            begin
                if (update_pc == 1) begin
                    data_out <= {`NPHLT, `NOP, 9'b0};
                    dependency_out <= {`NPHLT, `NOP, 9'b0};
                end
                else begin
                    if (freeze == 1) begin
                        dependency_out <= dependency_out;
                        data_out <= data_out;
                    end
                    else begin
                        dependency_out <= data_in;
                        data_out <= data_in;
                    end
                end
            end
        18 : 
            begin
                if (update_pc == 1) begin
                    data_out <= {`NOP, 14'b0};
                    dependency_out <= {`NOP, 3'b0};
                end
                else begin
                    if (freeze == 1) begin
                        data_out <= {`NOP, 14'b0};
                        dependency_out <= {`NOP, 3'b0};
                    end
                    else begin
                        if (MuxData[33:32] == 2'b01) begin
                            operands_out[63:32] <= MuxData[31:0];
                            operands_out[31:0] <= operands_in[31:0];
                        end
                        else if (MuxData[33:32] == 2'b10) begin
                            operands_out[31:0] <= MuxData[31:0];
                            operands_out[63:32] <= operands_in[63:32];
                        end
                        else begin
                            operands_out <= operands_in; 
                        end
                        data_out <= data_in;
                        dependency_out <= data_in[18:11];
                    end
                end
            end 
        41 :
            begin
                data_out <= data_in;
                dependency_out <= data_in[41:34];
                new_operand <= data_in[33:2];
            end
    endcase
end
endmodule
