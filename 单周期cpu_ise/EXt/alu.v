`include "ctrl_encode_def.v"

module alu(A,
           B,
           ALUOp,
           C,
           Zero);
    
    input  signed [31:0] A, B;
    input         [3:0]  ALUOp;
    output signed [31:0] C;
    output Zero;
    
    reg [31:0] C;
    integer i;
    
    always @(*)
    begin
        case (ALUOp)
            `ALU_NOP:
            C <= A;
            `ALU_ADD:
            C <= A+B;
            `ALU_SUB:
            C <= A-B;
            `ALU_AND:
            C <= A&B;
            `ALU_OR:
            C <= A|B;
            `ALU_XOR:
            C <= A^B;
            `ALU_SL:
            C <= A<<B;
            `ALU_SRL:
            C <= A>>B;
            `ALU_SRA:
            C <= A>>>B;
            `ALU_LT:
            begin
                if (A[31]<B[31])
                    C <= 0;
                else if (A[31]>B[31])
                    C <= 1;
                else 
                begin
                    if (A[30:0]<B[30:0])
                        C <= 1;
                    else
                        C <= 0;
                end
            end
            `ALU_LTU:
            begin
                if (A[31:0]<B[31:0])
                    C <= 1;
                else
                    C <= 0;
            end
				`ALU_B:
            begin
                C <= B;
            end
            default:
            C <= A;
        endcase
    end // end always
    
    assign Zero = (C == 32'b0);
    
endmodule
    
