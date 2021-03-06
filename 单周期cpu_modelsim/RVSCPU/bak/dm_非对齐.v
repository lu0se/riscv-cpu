
// data memory
module dm(clk,
          DMWr,
          addr,
          din,
	  ls,
          dout);
    input          clk;
    input          DMWr;
    input  [31:0]  addr;
    input  [31:0]  din;
    input  [3:0]   ls;
    output reg [31:0]  dout;
    
    reg [7:0] dmem[1024:0];
    
    //lwtype
    //w             4'b0000
    //h             4'b1000
    //b             4'b0100
    //hu            4'b0010
    //bu            4'b0001
    
    always @(posedge clk)
        if (DMWr) begin
            case(ls)
                4'b0000:begin
                    dmem[addr] <= din[7:0];
                    dmem[addr+1] <= din[15:8];
                    dmem[addr+2] <= din[23:16];
                    dmem[addr+3] <= din[31:24];
                end
                4'b1000:begin
                    dmem[addr] <= din[7:0];
                    dmem[addr+1] <= din[15:8];
                end
                4'b0100:begin
                    dmem[addr] <= din[7:0];
                end
            endcase
        end
    
    always @(negedge clk) begin
        case(ls)
            4'b0000:begin
                dout = {dmem[addr+3],dmem[addr+2],dmem[addr+1],dmem[addr]};
            end
            4'b1000:begin
                dout = {{16{dmem[addr+1][7]}},dmem[addr+1],dmem[addr]};
            end
            4'b0100:begin
                dout = {{16{dmem[addr][7]}},dmem[addr]};
            end
            4'b0010:begin
                dout = {{16{1'b0}},dmem[addr+1],dmem[addr]};           
            end
            4'b0001:begin
                dout = {{24{1'b0}},dmem[addr]};             
            end
        endcase
    end    
endmodule
