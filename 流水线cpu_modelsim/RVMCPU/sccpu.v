module sccpu(clk,
             rst,
             instr,
             readdata,
             PC,
             MemWrite,
             aluout,
             writedata,
	     ls,
             reg_sel,
             reg_data);
    
    input      clk;          // clock
    input      rst;          // reset
    
    input [31:0]  instr;     // instruction
    input [31:0]  readdata;  // data from data memory
    
    output [31:0] PC;        // PC address
    output        MemWrite;  // memory write
    output [31:0] aluout;    // ALU output
    output [31:0] writedata; // data to data memory
    output [3:0]   ls;       // load and write type whb
    
    input  [4:0] reg_sel;    // register selection (for debug use)
    output [31:0] reg_data;  // selected register data (for debug use)
    
    wire        RegWrite;    // control signal to register write
    wire [4:0]  EXTOp;       // control signal to signed extension
    wire [3:0]  ALUOp;       // ALU opertion
    wire [1:0]  NPCOp;       // next PC operation
    wire [1:0]  WDSel;       // (register) write data selection
    wire [1:0]  GPRSel;      // general purpose register selection
    
    wire        ALUSrc;      // ALU source for B
    wire        Zero;        // ALU ouput zero
    
    wire [31:0] NPC;         // next PC
    
    wire [4:0]  rs1;          // rs
    wire [4:0]  rs2;          // rt
    wire [4:0]  rd;          // rd
    wire [6:0]  Op;          // opcode
    wire [6:0]  Funct7;       // funct7
    wire [2:0]  Funct3;       // funct3
    wire [11:0] Imm12;       // 12-bit immediate
    wire [31:0] Imm32;       // 32-bit immediate
    wire [19:0] IMM;         // 20-bit immediate (address)
    wire [31:0] WD;          // register write data
    wire [31:0] RD1;         // register data specified by rs
    wire [31:0] B;           // operator for ALU B
    
    
    assign Op     = instr[6:0];  // instruction
    assign Funct7 = instr[31:25]; // funct7
    assign Funct3 = instr[14:12]; // funct3
    assign rs1    = instr[19:15];  // rs1
    assign rs2    = instr[24:20];  // rs2
    assign rd     = instr[11:7];  // rd
    assign Imm12  = instr[31:20];// 12-bit immediate
    assign IMM    = instr[31:12];  // 20-bit immediate
    
    RF U_RF(
       .clk(clk),
       .rst(rst),
       .RFWr(RegWrite),
       .A1(rs1),.A2(rs2),
       .A3(rd),
       .WD(WD),
       .RD1(RD1),
       .RD2(writedata),
       .reg_sel(reg_sel),
       .reg_data(reg_data)
       );
    // instantiation of control unit
    ctrl U_ctrl(
         .Op(Op), 
         .Funct7(Funct7),
         .Funct3(Funct3), 
         .Zero(Zero), 
         .RegWrite(RegWrite), 
         .MemWrite(MemWrite),
         .EXTOp(EXTOp), 
         .ALUOp(ALUOp), 
         .NPCOp(NPCOp), 
         .ALUSrc(ALUSrc),
         .ls(ls),
         .WDSel(WDSel)
         );
    // instantiation of pc unit
    NPC U_NPC(
	.PC(PC),
	.NPCOp(NPCOp),
	.IMM(Imm32),
        .C(aluout),
	.NPC(NPC)
	);
    PC U_PC(
       .clk(clk),
       .rst(rst),
       .NPC(NPC),
       .PC(PC)
       );
    // instantiation of alu unit
    EXT U_EXT(
	.iimm(Imm12),
	.simm({Funct7,rd}),
	.bimm({Funct7[6],rd[0],Funct7[5:0],rd[4:1]}),
	.uimm(IMM),.jimm(IMM),
	.EXTOp(EXTOp),
	.immout(Imm32)
	);
    mux_from_rs2_EXT_to_alu U_mux_from_EXT_im_to_alu(
			    .ALUSrc(ALUSrc),
			    .RD2(writedata),
			    .imm(Imm32),
			    .B(B)
			    );
    alu U_alu(
	.A(RD1),
	.B(B),
	.ALUOp(ALUOp),
	.C(aluout),
	.Zero(Zero)
	);
    
    mux_from_dm_alu_to_RF U_mux_from_dm_alu_to_RF(
			  .WDSel(WDSel),
			  .C(aluout),
			  .readdata(readdata),
			  .PC(PC),
			  .WD(WD)
			  );
        
endmodule
