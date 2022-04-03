// `include "ctrl_encode_def.v"


module ctrl(Op,
            Funct7,
            Funct3,
            Zero,
            RegWrite,
            MemWrite,
            EXTOp,
            ALUOp,
            NPCOp,
            ALUSrc,
            ls,
            WDSel);
    
    input  [6:0] Op;       // opcode
    input  [6:0] Funct7;    // funct7
    input  [2:0] Funct3;    // funct3
    input        Zero;
    
    output       RegWrite; // control signal for register write
    output       MemWrite; // control signal for memory write
    output [4:0] EXTOp;    // control signal to signed extension
    output [3:0] ALUOp;    // ALU opertion
    output [1:0] NPCOp;    // next pc operation
    output       ALUSrc;   // ALU source for B
    output [1:0] WDSel;    // (register) write data selection
    output [3:0] ls;   // load and write type whb
    
    // r format
    wire rtype  = ~Op[6]&Op[5]&Op[4]&~Op[3]&~Op[2]&Op[1]&Op[0];
    wire i_add  = rtype& ~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]&~Funct3[2]&~Funct3[1]&~Funct3[0]; // add
    wire i_sub  = rtype& ~Funct7[6]& Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]&~Funct3[2]&~Funct3[1]&~Funct3[0]; // sub
    wire i_sll  = rtype& ~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]&~Funct3[2]&~Funct3[1]&Funct3[0]; //sll
    wire i_slt  = rtype& ~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]&~Funct3[2]&Funct3[1]&~Funct3[0];//slt
    wire i_sltu = rtype& ~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]&~Funct3[2]&Funct3[1]&Funct3[0];//sltu
    wire i_xor  = rtype& ~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]&Funct3[2]&~Funct3[1]&~Funct3[0];//xor
    wire i_srl  = rtype& ~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]&Funct3[2]&~Funct3[1]&Funct3[0];//srl
    wire i_sra  = rtype& ~Funct7[6]& Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]&Funct3[2]&~Funct3[1]&Funct3[0];//sra
    wire i_or   = rtype& ~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]& Funct3[2]& Funct3[1]&~Funct3[0]; // or
    wire i_and  = rtype& ~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]& Funct3[2]& Funct3[1]& Funct3[0]; // and
    
    // i format
    wire itype   = ~Op[6]&~Op[5]&Op[4]&~Op[3]&~Op[2]&Op[1]&Op[0];
    wire i_addi  = itype&~Funct3[2]&~Funct3[1]&~Funct3[0]; // addi
    wire i_slti  = itype&~Funct3[2]& Funct3[1]&~Funct3[0]; // slti
    wire i_sltiu = itype&~Funct3[2]& Funct3[1]& Funct3[0]; // sltiu
    wire i_xori  = itype& Funct3[2]&~Funct3[1]&~Funct3[0]; // xori
    wire i_ori   = itype& Funct3[2]& Funct3[1]&~Funct3[0]; // ori
    wire i_andi  = itype& Funct3[2]& Funct3[1]& Funct3[0]; // andi
    
    wire sxli      = ~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0];
    wire sxai      = ~Funct7[6]& Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0];
    wire shamttype = (sxli|sxai)&itype;
    wire i_slli    = shamttype&sxli&~Funct3[2]&~Funct3[1]& Funct3[0]; //slli
    wire i_srli    = shamttype&sxli& Funct3[2]&~Funct3[1]& Funct3[0]; //srli
    wire i_srai    = shamttype&sxai& Funct3[2]&~Funct3[1]& Funct3[0]; //srai
    
    
    // i format
    wire ltype = ~Op[6]&~Op[5]&~Op[4]&~Op[3]&~Op[2]&Op[1]&Op[0];
    wire i_lb  = ltype& ~Funct3[2]&~Funct3[1]&~Funct3[0]; // lb
    wire i_lh  = ltype& ~Funct3[2]&~Funct3[1]& Funct3[0]; // lh
    wire i_lw  = ltype& ~Funct3[2]& Funct3[1]&~Funct3[0]; // lw
    wire i_lbu = ltype&  Funct3[2]&~Funct3[1]&~Funct3[0]; // lbu
    wire i_lhu = ltype&  Funct3[2]&~Funct3[1]& Funct3[0]; // lhu
    
    // i format
    wire i_jalr = Op[6]& Op[5]&~Op[4]&~Op[3]& Op[2]& Op[1]& Op[0]&~Funct3[2]&~Funct3[1]&~Funct3[0];//jalr
    
    // s format
    wire stype = ~Op[6]&Op[5]&~Op[4]&~Op[3]&~Op[2]&Op[1]&Op[0];
    wire i_sb  = stype& ~Funct3[2]&~Funct3[1]&~Funct3[0]; // sb
    wire i_sh  = stype& ~Funct3[2]&~Funct3[1]& Funct3[0]; // sh
    wire i_sw  = stype& ~Funct3[2]& Funct3[1]&~Funct3[0]; // sw
    
    // sb format
    wire sbtype = Op[6]&Op[5]&~Op[4]&~Op[3]&~Op[2]&Op[1]&Op[0];
    wire i_beq  = sbtype& ~Funct3[2]& ~Funct3[1]&~Funct3[0]; // beq
    wire i_bne  = sbtype& ~Funct3[2]& ~Funct3[1]& Funct3[0]; // bne
    wire i_blt  = sbtype&  Funct3[2]& ~Funct3[1]&~Funct3[0]; // blt
    wire i_bge  = sbtype&  Funct3[2]& ~Funct3[1]& Funct3[0]; // bge
    wire i_bltu = sbtype&  Funct3[2]&  Funct3[1]&~Funct3[0]; // bltu
    wire i_bgeu = sbtype&  Funct3[2]&  Funct3[1]& Funct3[0]; // bgeu
    
    // u format
    wire i_lui   =~Op[6]& Op[5]& Op[4]&~Op[3]& Op[2]& Op[1]& Op[0];  // lui
    wire i_auipc = ~Op[6]&~Op[5]& Op[4]& ~Op[3]& Op[2]& Op[1]& Op[0];  // auipc
    
    // j format
    wire i_jal =  Op[6]& Op[5]&~Op[4]& Op[3]& Op[2]& Op[1]& Op[0];  // jal
    
    // generate control signals
    assign RegWrite = rtype | ltype |itype| i_jalr | i_jal | i_auipc | i_lui; // register write
    
    assign MemWrite = stype;                           // memory write
    assign ALUSrc   = ltype|itype|stype|i_jal|i_jalr|i_lui|i_auipc;   // ALU B is from instruction immediate
    
    // signed extension
    // SHAMT            5'b11111
    // EXT_CTRL_ITYPE	5'b10000
    // EXT_CTRL_STYPE	5'b01000
    // EXT_CTRL_BTYPE	5'b00100
    // EXT_CTRL_UTYPE	5'b00010
    // EXT_CTRL_JTYPE	5'b00001
    assign EXTOp[4] = itype | ltype|i_jalr|shamttype;
    assign EXTOp[3] = stype|shamttype;
    assign EXTOp[2] = sbtype|shamttype;
    assign EXTOp[1] = i_lui|i_auipc|shamttype;
    assign EXTOp[0] = i_jal|shamttype;
    
    
    
    // WDSel_FromALU 2'b00
    // WDSel_FromMEM 2'b01
    // WDSel_FromPC  2'b10
	 // WDSel_FromPC+ALU(B) 2'b11
    assign WDSel[0] = ltype|i_auipc;
    assign WDSel[1] = i_jal|i_jalr|i_auipc;
    
    // NPC_PLUS4   2'b00
    // NPC_BRANCH  2'b01
    // NPC_JUMP    2'b10
    assign NPCOp[0] = (i_beq & Zero)|(i_bne & ~Zero)|(i_blt&~Zero)|(i_bge& Zero)|(i_bltu&~Zero)|(i_bgeu& Zero)|i_jalr;
    assign NPCOp[1] = i_jal|i_jalr;
    
    
    // ALU_NOP   4'b0000
    // ALU_ADD   4'b0001
    // ALU_SUB   4'b0010
    // ALU_AND   4'b0011
    // ALU_OR    4'b0100
    // ALU_XOR   4'b0101
    // ALU_SL    4'b0110
    // ALU_SRL   4'b0111
    // ALU_SRA   4'b1000
    // ALU_LT    4'b1001
    // ALU_LTU   4'b1010
	 // ALU_B 	  4'b1011
    assign ALUOp[0] = i_add | i_lw | i_lh |i_lb |i_lbu | i_lhu | i_sw | i_addi | i_and |i_slt|i_srl|i_slti|i_xor|i_xori|i_andi|i_srli | i_jalr |stype|i_blt |i_bge|i_lui|i_auipc;
    assign ALUOp[1] = i_sub | i_beq | i_and | i_sll| i_sltu|i_srl|i_sltiu|i_andi|i_slli|i_srli|i_bne|i_bltu|i_bgeu|i_lui|i_auipc;
    assign ALUOp[2] = i_or | i_ori | i_sll|i_srl|i_xor|i_xori|i_ori|i_slli|i_srli;
    assign ALUOp[3] = i_slt | i_sltu |i_sra||i_slti|i_sltiu|i_srai|i_blt |i_bge|i_bltu|i_bgeu|i_lui|i_auipc;
    
    
    
    //lstype
    //w             4'b0000
    //h             4'b1000
    //b             4'b0100
    //hu            4'b0010
    //bu            4'b0001
    assign ls[3] = i_sh|i_lh;
    assign ls[2] = i_sb|i_lb;
    assign ls[1] = i_lhu;
    assign ls[0] = i_lbu;
endmodule
