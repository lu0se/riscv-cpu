// NPC control signal
`define NPC_PLUS4   2'b00
`define NPC_BRANCH  2'b01
`define NPC_JUMP    2'b10
`define NPC_JALR    2'b11


// ALU control signal
`define ALU_NOP   4'b0000
`define ALU_ADD   4'b0001
`define ALU_SUB   4'b0010
`define ALU_AND   4'b0011
`define ALU_OR    4'b0100
`define ALU_XOR   4'b0101
`define ALU_SL    4'b0110
`define ALU_SRL   4'b0111
`define ALU_SRA   4'b1000
`define ALU_LT    4'b1001
`define ALU_LTU   4'b1010

//EXT CTRL itype, stype, btype, utype, jtype
`define SHAMT           5'b11111
`define EXT_CTRL_ITYPE	5'b10000
`define EXT_CTRL_STYPE	5'b01000
`define EXT_CTRL_BTYPE	5'b00100
`define EXT_CTRL_UTYPE	5'b00010
`define EXT_CTRL_JTYPE	5'b00001

