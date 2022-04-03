module forwardingunit (
    input EX_MEM_RegWrite,
    input [4:0] EX_MEM_RegisterRd,
    input [4:0] ID_EX_RegisterRs1,
    input [4:0] ID_EX_RegisterRs2,
    input MEM_WB_RegWrite,
    input [4:0] MEM_WB_RegisterRd,
    output reg [1:0] ForwardA,
    output reg [1:0] ForwardB
);
    always @(*) begin
        if (EX_MEM_RegWrite& (EX_MEM_RegisterRd != 0)& (EX_MEM_RegisterRd == ID_EX_RegisterRs1)) 
            ForwardA <= 2'b10;
        else if (MEM_WB_RegWrite& (MEM_WB_RegisterRd != 0)& ~(EX_MEM_RegWrite & (EX_MEM_RegisterRd != 0)& (EX_MEM_RegisterRd == ID_EX_RegisterRs1))& (MEM_WB_RegisterRd == ID_EX_RegisterRs1)) 
            ForwardA <= 2'b01;
        else
            ForwardA <= 2'b00;
        if (EX_MEM_RegWrite& (EX_MEM_RegisterRd != 0)& (EX_MEM_RegisterRd == ID_EX_RegisterRs2)) 
            ForwardB <= 2'b10;
        else if (MEM_WB_RegWrite& (MEM_WB_RegisterRd != 0)& ~(EX_MEM_RegWrite & (EX_MEM_RegisterRd != 0)& (EX_MEM_RegisterRd == ID_EX_RegisterRs2))& (MEM_WB_RegisterRd == ID_EX_RegisterRs2)) 
            ForwardB <= 2'b01;
        else
            ForwardB <= 2'b00;
    end
endmodule