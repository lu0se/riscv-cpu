module mccpu(
    clk,
    rst,
    instr,
    readdata,
    PC,
    MemWrite,
    aluout,
    writedata,
	ls,
    reg_sel,
    reg_data
    );
    
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

    //IF
	 
	
    wire [109:0] EXEMEMIN,EXEMEMOUT;
    wire data_nstall;
    wire [31:0] NPC2if;
    wire jump;
    pipeif U_pipeif(
        .clk(clk),
        .rst(rst),
        .PCOP(jump),
        .write_enable(data_nstall),
        .NPC(NPC2if),
        .PC(PC)
    );
    wire IFIDflush=(~data_nstall)|jump;
    wire [63:0] IFIDOUT;
    GRE_array #(. WIDTH(64)) IFID(.Clk(clk),.Rst(rst),.write_enable(data_nstall),.flush(IFIDflush),.in({instr,PC}),.out(IFIDOUT));
    wire [31:0] instr2id=IFIDOUT[63:32];


    //ID
    wire [159:0] IDEXIN,IDEXOUT;
    wire Memread;



    wire [39:0]MEMWBIN,MEMWBOUT;
    wire [31:0] WD2id=MEMWBOUT[39:8];
    wire [4:0] rd2id=MEMWBOUT[7:3];
    wire Regwrite2id=MEMWBOUT[2];

    pipeid U_pipeid(
        .clk(clk),
        .rst(rst),
        .instr(instr2id),
        .RegWrite(Regwrite2id),
        .rd(rd2id),
        .WD(WD2id),
        .RD12exe(IDEXIN[116:85]),
        .RD22exe(IDEXIN[84:53]),
        .ALUOp2exe(IDEXIN[52:49]),
        .NPCOp2exe(IDEXIN[48:47]), 
        .ALUSrc2exe(IDEXIN[46]),
        .Imm322exe(IDEXIN[45:14]),
        .Zero_12exe(IDEXIN[13]),
        .MemWrite2mem(IDEXIN[12]),
        .ls2mem(IDEXIN[11:8]),
        .rd2wb(IDEXIN[7:3]),
        .RegWrite2wb(IDEXIN[2]),
        .WDSel2wb(IDEXIN[1:0]),
        .Memread(Memread)
    );
    hazard_detection U_hazard_detection(
        .ID_EX_MemRead(IDEXOUT[149]),
        .ID_EX_RegisterRd(IDEXOUT[7:3]),
        .IF_ID_RegisterRs1(instr2id[19:15]),
        .IF_ID_RegisterRs2(instr2id[24:20]),
        .data_nstall(data_nstall)
    );

    wire IDEXflush=jump|(~data_nstall);
    assign IDEXIN[154:150]=instr2id[19:15];
    assign IDEXIN[159:155]=instr2id[24:20];
    assign IDEXIN[149]=Memread;
    assign IDEXIN[148:117]=IFIDOUT[31:0];
    GRE_array #(. WIDTH(160)) IDEX(.Clk(clk),.Rst(rst),.write_enable(1'b1),.flush(IDEXflush),.in(IDEXIN),.out(IDEXOUT));
    wire ALUSrc2exe=IDEXOUT[46];
    wire [31:0] RD12exe=IDEXOUT[116:85];
    wire [31:0] RD22exe=IDEXOUT[84:53];
    wire [31:0] Imm322exe=IDEXOUT[45:14];
    wire [3:0] ALUOp2exe=IDEXOUT[52:49];
    wire [31:0] PC2exe=IDEXOUT[148:117];
    wire [1:0] NPCOp2exe=IDEXOUT[48:47];
    wire Zero_12exe=IDEXOUT[13];
    
    //EXE
    wire [1:0] ForwardA,ForwardB;
    pipeexe U_pipeexe(
        .ALUSrc(ALUSrc2exe),
        .RD1(RD12exe),
        .RD2(RD22exe),
        .Imm32(Imm322exe),
        .ALUOp(ALUOp2exe),
        .PC(PC2exe),
        .NPCOp(NPCOp2exe),
        .Zero_1(Zero_12exe),
        .ForwardA(ForwardA),
        .ForwardB(ForwardB),
        .EX_MEM_Register(EXEMEMOUT[76:45]),
        .MEM_WB_Register(MEMWBOUT[39:8]),
        .aluout(EXEMEMIN[76:45]),
        .NPC2if(NPC2if),
        .jump2if(jump),
        .Bs(EXEMEMIN[44:13])
    );
    forwardingunit U_forwardingunit(
        .EX_MEM_RegWrite(EXEMEMOUT[2]),
        .EX_MEM_RegisterRd(EXEMEMOUT[7:3]),
        .ID_EX_RegisterRs1(IDEXOUT[154:150]),
        .ID_EX_RegisterRs2(IDEXOUT[159:155]),
        .MEM_WB_RegWrite(MEMWBOUT[2]),
        .MEM_WB_RegisterRd(MEMWBOUT[7:3]),
        .ForwardA(ForwardA),
        .ForwardB(ForwardB)
    );

    assign EXEMEMIN[7:0]=IDEXOUT[7:0]; //wbreg
    assign EXEMEMIN[12:8]=IDEXOUT[12:8];//memreg     EXEMEMIN[44:13] memwritedata
    assign EXEMEMIN[108:77]=PC2exe;
    GRE_array #(. WIDTH(109)) EXEMEM(.Clk(clk),.Rst(rst),.write_enable(1'b1),.flush(1'b0),.in(EXEMEMIN),.out(EXEMEMOUT));


    //MEM

    assign MemWrite=EXEMEMOUT[12];
    assign aluout=EXEMEMOUT[76:45];
    assign writedata=EXEMEMOUT[44:13];
    assign ls=EXEMEMOUT[11:8];

    wire [1:0] WDSel=EXEMEMOUT[1:0];
    wire [31:0] PC2muxRF=EXEMEMOUT[108:77];
    wire [31:0] WD2RF;
    mux_from_dm_alu_to_RF U_mux_from_dm_alu_to_RF(
		.WDSel(WDSel),
		.C(aluout),
		.readdata(readdata),
		.PC(PC2muxRF),
		.WD(WD2RF)
	);

    assign MEMWBIN[7:0]=EXEMEMOUT[7:0];
    assign MEMWBIN[39:8]=WD2RF;
    GRE_array #(. WIDTH(40)) MEMWB(.Clk(clk),.Rst(rst),.write_enable(1'b1),.flush(1'b0),.in(MEMWBIN),.out(MEMWBOUT));
    //WB
    //write back from MEMWB Reg


endmodule