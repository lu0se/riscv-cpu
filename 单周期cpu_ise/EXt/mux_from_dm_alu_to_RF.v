module mux_from_dm_alu_to_RF(input [1:0] WDSel,
                             input [31:0] C,
                             input [31:0] readdata,
                             input [31:0] PC,
                             output reg [31:0] WD);
    always @(*) begin
        case (WDSel)
            2'b00:begin
                WD <= C;
            end
            2'b01:begin
                WD <= readdata;
            end
            2'b10:begin
                WD <= PC+4;
            end
				2'b11:begin
					WD <= PC+C;
				end
				default:begin
					WD <=PC+4;
				end
        endcase
    end
endmodule
