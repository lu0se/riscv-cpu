`include "ctrl_encode_def.v"

module NPC(PC,
           NPCOp,
           IMM,
           C,
           branch,
           NPC,
           jump);  // next pc module
    
    input  [31:0] PC;        // pc
    input  [1:0]  NPCOp;     // next pc operation
    input  [31:0] IMM;       // immediate
    input  [31:0] C;         //C from ALU for jalr
    input branch;
    output reg [31:0] NPC;   // next pc
    output reg jump;

    wire [31:0] PCPLUS4;
    
    assign PCPLUS4 = PC + 4; // pc + 4
    
    always @(*) begin
        case (NPCOp)
            `NPC_PLUS4:begin
                NPC <= PCPLUS4;
                jump<=0;
            end
            `NPC_BRANCH:begin
                if(branch) begin
                    NPC <= PC + {{19{IMM[12]}}, IMM[12:2], 2'b00};
                    jump <=1;
                end
                else begin
                    NPC <=PCPLUS4;
                    jump<=0;
                end
            end
            `NPC_JUMP:begin
                NPC <= PC + {{11{IMM[20]}}, IMM[20:2], 2'b00};
                jump<=1;
            end
            `NPC_JALR:begin
                NPC <= C;
                jump<=1;
            end 
            default:begin
                NPC <= PCPLUS4;
                jump<=0;
            end
        endcase
    end // end always
    
endmodule
