module pipeid (
    input clk,
    input rst,
    input [31:0] instr,
    input RegWrite,
    input [4:0] rd,
    input [31:0] WD,
    output [31:0] RD12exe,RD22exe,
    output [4:0] rd2wb,
    output RegWrite2wb,
    output MemWrite2mem,
    output [3:0] ALUOp2exe,
    output [1:0] NPCOp2exe,
    output ALUSrc2exe,
    output [3:0] ls2mem,
    output [1:0] WDSel2wb,
    output [31:0] Imm322exe,
    output Zero_12exe,
    output Memread
);
    wire [4:0]  rs1;          // rs
    wire [4:0]  rs2;          // rt 
    wire [6:0]  Op;          // opcode
    wire [6:0]  Funct7;       // funct7
    wire [2:0]  Funct3;       // funct3
    wire [11:0] Imm12;       // 12-bit immediate
    wire [19:0] IMM;         // 20-bit immediate (address)

    wire [4:0] EXTOp;

    assign Op     = instr[6:0];  // instruction
    assign Funct7 = instr[31:25]; // funct7
    assign Funct3 = instr[14:12]; // funct3
    assign rs1    = instr[19:15];  // rs1
    assign rs2    = instr[24:20];  // rs2
    assign rd2wb  = instr[11:7];  // rd for wb
    assign Imm12  = instr[31:20];// 12-bit immediate
    assign IMM    = instr[31:12];  // 20-bit immediate


    RF U_RF(
       .clk(clk),
       .rst(rst),
       .RFWr(RegWrite),
       .A1(rs1),.A2(rs2),
       .A3(rd),
       .WD(WD),
       .RD1(RD12exe),
       .RD2(RD22exe),
       .reg_sel(),
       .reg_data()
       );
    ctrl U_ctrl(
        .Op(Op), 
        .Funct7(Funct7),
        .Funct3(Funct3), 
        .RegWrite(RegWrite2wb), 
        .MemWrite(MemWrite2mem),
        .EXTOp(EXTOp), 
        .ALUOp(ALUOp2exe), 
        .NPCOp(NPCOp2exe), 
        .ALUSrc(ALUSrc2exe),
        .ls(ls2mem),
        .WDSel(WDSel2wb),
        .Zero_1(Zero_12exe),
        .Memread(Memread)
         );
    EXT U_EXT(
	    .iimm(Imm12),
	    .simm({Funct7,rd2wb}),
	    .bimm({Funct7[6],rd2wb[0],Funct7[5:0],rd2wb[4:1]}),
	    .uimm(IMM),.jimm(IMM),
	    .EXTOp(EXTOp),
	    .immout(Imm322exe)
	);
endmodule