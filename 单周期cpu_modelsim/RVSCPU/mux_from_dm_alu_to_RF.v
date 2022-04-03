module mux_from_dm_alu_to_RF(input [1:0] WDSel,
                             input [31:0] C,
                             input [31:0] readdata,
                             input [31:0] PC,
                             output [31:0] WD);
    reg [31:0] WD_r;
    always @(*) begin
        case (WDSel)
            2'b00:begin
                WD_r <= C;
            end
            2'b01:begin
                WD_r <= readdata;
            end
            2'b10:begin
                WD_r <= PC+4;
            end
        endcase
    end
    assign WD = WD_r;
endmodule
