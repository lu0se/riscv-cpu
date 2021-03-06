module mux_from_rs1_pc_to_alu(input [1:0] ALUSrc_A,
                              input [31:0] RD1,
                              input [31:0] PC,
                              output [31:0] A);
    reg [31:0] A_r;
    always @(*) begin
        case (ALUSrc_A)
            2'b00:begin
                A_r <= RD1;
            end
            2'b01:begin
                A_r <= {32{1'b0}};
            end
            2'b10:begin
                A_r <= PC;
            end
        endcase
    end
    assign A = A_r;
endmodule
