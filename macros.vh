//registers
`define R0 3'b0
`define R1 3'b001
`define R2 3'b010
`define R3 3'b011
`define R4 3'b100
`define R5 3'b101
`define R6 3'b110
`define R7 3'b111

//prefixe instructiuni
`define NPHLT 2'b00
`define ALU 2'b01
`define LDST 2'b10
`define JUMP 2'b11

//instructiuni NPHLT
`define NOP 5'b00001
`define HALT 5'b00010

//instructiuni ALU
`define ADD 5'b00011
`define ADDF 5'b00100
`define SUB 5'b00101
`define SUBF 5'b00110
`define AND 5'b00111
`define OR 5'b01000
`define XOR 5'b01001
`define NAND 5'b01010
`define NOR 5'b01011
`define NXOR 5'b01100
`define SHIFTR 5'b01101
`define SHIFTRA 5'b01110
`define SHIFTL 5'b01111

//instructiuni LOAD/STORE
`define LOAD 3'b000
`define LOADC 3'b001
`define STORE 3'b010

`define LOADv2 5'b10000
`define LOADCv2 5'b10001
`define STOREv2 5'b10010

//instructiuni JUMP
`define JMP 2'b00
`define JMPR 2'b01
`define JMP_cond1 2'b10
`define JMP_cond2 2'b11

`define JMPv2 5'b10011
`define JMPRv2 5'b10100
`define JMP_cond1v2 5'b10101
`define JMP_cond2v2 5'b10110

//JMP conditions:
`define cond1 3'b000 // R[op0] < 0
`define cond2 3'b001 // R[op0] >= 0
`define cond3 3'b010 // R[op0] == 0
`define cond4 3'b011 // R[op0] != 0
