module pipeif (
    input clk,
    input rst,
    input PCOP,
    input write_enable,
    input [31:0] NPC,
    output [31:0] PC
);
    wire [31:0] muxNPC;
    mux_from_exe_pcplus4_to_pipeif U_mux_mux_from_exe_pcplus4_to_pipeif(
        .PCOP(PCOP),
        .NPC(NPC),
        .PC(PC),
        .muxNPC(muxNPC)
    );
    PC U_PC(
        .clk(clk),
        .rst(rst),
        .write_enable(write_enable),
        .NPC(muxNPC),
        .PC(PC)
    );
endmodule