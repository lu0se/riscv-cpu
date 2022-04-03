module mux_from_exe_pcplus4_to_pipeif(
    input  PCOP,
    input [31:0] NPC,
    input [31:0] PC,
    output reg [31:0] muxNPC);
    always @(*) begin
        case (PCOP)
            1'b0:begin
                muxNPC <= PC+4;
            end
            1'b1:begin
                muxNPC <= NPC;
            end
            default:begin
                muxNPC <= PC+4;
            end
        endcase
    end
endmodule
