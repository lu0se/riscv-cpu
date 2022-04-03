module hazard_detection (
    input ID_EX_MemRead,
    input [4:0] ID_EX_RegisterRd,
    input [4:0] IF_ID_RegisterRs1,
    input [4:0] IF_ID_RegisterRs2,
    output reg data_nstall
);
    always @(*) begin
        if(ID_EX_MemRead &((ID_EX_RegisterRd == IF_ID_RegisterRs1)|(ID_EX_RegisterRd == IF_ID_RegisterRs2)))begin
            data_nstall<=0;
        end 
        else begin
            data_nstall<=1;    
        end
    end
endmodule