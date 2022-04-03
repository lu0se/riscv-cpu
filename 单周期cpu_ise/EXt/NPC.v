`include "ctrl_encode_def.v"

module NPC(PC,
           NPCOp,
           IMM,
           C,
           NPC);  // next pc module
    
    input  [31:0] PC;        // pc
    input  [1:0]  NPCOp;     // next pc operation
    input  [31:0] IMM;       // immediate
    input  [31:0] C;         //C from ALU for jalr
    output reg [31:0] NPC;   // next pc
    
    wire [31:0] PCPLUS4;
    
    assign PCPLUS4 = PC + 4; // pc + 4
    
    always @(*) begin
        case (NPCOp)
            `NPC_PLUS4:  NPC <= PCPLUS4;
            `NPC_BRANCH: NPC <= PC + {{19{IMM[12]}}, IMM[12:2], 2'b00};
            `NPC_JUMP:   NPC <= PC + {{11{IMM[20]}}, IMM[20:2], 2'b00};
            `NPC_JALR:   NPC <= C;
            default:     NPC <= PCPLUS4;
        endcase
    end // end always
    
endmodule
