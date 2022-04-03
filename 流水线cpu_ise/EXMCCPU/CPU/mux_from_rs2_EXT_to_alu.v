module mux_from_rs2_EXT_to_alu(input ALUSrc,
                               input [31:0] RD2,
                               input [31:0] imm,
                               output reg [31:0] B);
    always @(*) begin
        case (ALUSrc)
            1'b0:begin
                B <= RD2;
            end
            1'b1:begin
                B <= imm;
            end
        endcase
    end
endmodule
