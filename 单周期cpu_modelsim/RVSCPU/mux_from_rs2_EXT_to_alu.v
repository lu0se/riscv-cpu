module mux_from_rs2_EXT_to_alu(input ALUSrc,
                               input [31:0] RD2,
                               input [31:0] imm,
                               output [31:0] B);
    reg [31:0] B_r;
    always @(*) begin
        case (ALUSrc)
            1'b0:begin
                B_r <= RD2;
            end
            1'b1:begin
                B_r <= imm;
            end
        endcase
    end
    assign B = B_r;
endmodule
