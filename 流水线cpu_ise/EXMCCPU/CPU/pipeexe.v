module pipeexe (
    input ALUSrc,
    input [31:0] RD1,
    input [31:0] RD2,
    input [31:0] Imm32,
    input [3:0] ALUOp,
    input [31:0] PC,
    input [1:0] NPCOp,
    input Zero_1,
    input [1:0] ForwardA,
    input [1:0] ForwardB,
    input [31:0] EX_MEM_Register,
    input [31:0] MEM_WB_Register,
    output [31:0] aluout,
    output [31:0] NPC2if,
    output jump2if,
    output [31:0] Bs
);
    wire [31:0] A,B;
    wire Zero;
    mux_from_rs2_EXT_to_alu U_mux_from_EXT_im_to_alu(
	    .ALUSrc(ALUSrc),
	    .RD2(Bs),
	    .imm(Imm32),
	    .B(B)
	    );
    mux_from_forward_to_AB U_mux_from_forward_to_A(
        .Forward(ForwardA),
        .RD(RD1),
        .EX_MEM_Register(EX_MEM_Register),
        .MEM_WB_Register(MEM_WB_Register),
        .AB(A)
    );
    mux_from_forward_to_AB U_mux_from_forward_to_B(
        .Forward(ForwardB),
        .RD(RD2),
        .EX_MEM_Register(EX_MEM_Register),
        .MEM_WB_Register(MEM_WB_Register),
        .AB(Bs)
    );
    alu U_alu(
	    .A(A),
	    .B(B),
	    .ALUOp(ALUOp),
	    .C(aluout),
	    .Zero(Zero)
	);
    wire branch=~(Zero_1^Zero);//是否分支
    NPC U_NPC(
	    .PC(PC),
	    .NPCOp(NPCOp),
	    .IMM(Imm32),
        .C(aluout),
        .branch(branch),
	    .NPC(NPC2if),
        .jump(jump2if)
	);
endmodule