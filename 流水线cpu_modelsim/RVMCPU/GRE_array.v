module GRE_array #(
    parameter WIDTH
) (
    input Clk,Rst,write_enable,flush,
    input [WIDTH-1:0] in,
    output reg [WIDTH-1:0] out
);
    always @(negedge Clk) begin
        if(write_enable)begin
            if(flush)
                out=0;
            else
                out=in; 
        end
    end

    always @(posedge Rst) begin
        out=0;
    end
endmodule