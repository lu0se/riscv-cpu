module mux_from_forward_to_AB (
    input [1:0] Forward,
    input [31:0] RD,
    input [31:0] EX_MEM_Register,
    input [31:0] MEM_WB_Register,
    output reg [31:0] AB
);
    always @(*) begin
        case (Forward)
            2'b00:begin
                AB <= RD;
            end
            2'b01:begin
                AB <= MEM_WB_Register;
            end
            2'b10:begin
                AB <=EX_MEM_Register;
            end
            default:begin
                AB <= RD;
            end
        endcase
    end
endmodule