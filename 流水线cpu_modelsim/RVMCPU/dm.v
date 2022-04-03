
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
    
    reg [31:0] dmem[128:0];
    
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
                    dmem[addr[31:2]] <= din;
                    $display("dmem[0x%8X] = 0x%8X,", addr[31:2] << 2, din);
                end
                4'b1000:begin
                    case(addr[1:0])
                        2'b00:begin
                            dmem[addr[31:2]][15:0] <= din[15:0];
                        end
                        2'b10:begin
                            dmem[addr[31:2]][31:16] <= din[15:0];
                        end
                    endcase
                end
                4'b0100:begin
                    case(addr[1:0])
                        2'b00:begin
                            dmem[addr[31:2]][7:0] <= din[7:0];
                        end
                        2'b01:begin
                            dmem[addr[31:2]][15:8] <= din[7:0];
                        end
                        2'b10:begin
                            dmem[addr[31:2]][23:16] <= din[7:0];
                        end
                        2'b10:begin
                            dmem[addr[31:2]][31:24] <= din[7:0];
                        end
                    endcase
                end
            endcase
        end
    
    always @(negedge clk) begin
        case(ls)
            4'b0000:begin
                dout = dmem[addr[31:2]];
            end
            4'b1000:begin
                case (addr[1:0])
                    2'b00:begin
                        dout = {{16{dmem[addr[31:2]][15]}},dmem[addr[31:2]][15:0]};
                    end
                    2'b10:begin
                        dout = {{16{dmem[addr[31:2]][31]}},dmem[addr[31:2]][31:16]};
                    end
                endcase
            end
            4'b0100:begin
                case (addr[1:0])
                    2'b00:begin
                        dout = {{24{dmem[addr[31:2]][7]}},dmem[addr[31:2]][7:0]};
                    end
                    2'b01:begin
                        dout = {{24{dmem[addr[31:2]][15]}},dmem[addr[31:2]][15:8]};
                    end
                    2'b10:begin
                        dout = {{24{dmem[addr[31:2]][23]}},dmem[addr[31:2]][23:16]};
                    end
                    2'b11:begin
                        dout = {{24{dmem[addr[31:2]][31]}},dmem[addr[31:2]][31:24]};
                    end
                endcase
            end
            4'b0010:begin
                case (addr[1:0])
                    2'b00:begin
                        dout = {{16{1'b0}},dmem[addr[31:2]][15:0]};
                    end
                    2'b10:begin
                        dout = {{16{1'b0}},dmem[addr[31:2]][31:16]};
                    end
                endcase               
            end
            4'b0001:begin
                case (addr[1:0])
                    2'b00:begin
                        dout = {{24{1'b0}},dmem[addr[31:2]][7:0]};
                    end
                    2'b01:begin
                        dout = {{24{1'b0}},dmem[addr[31:2]][15:8]};
                    end
                    2'b10:begin
                        dout = {{24{1'b0}},dmem[addr[31:2]][23:16]};
                    end
                    2'b11:begin
                        dout = {{24{1'b0}},dmem[addr[31:2]][31:24]};
                    end
                endcase               
            end
        endcase
    end    
endmodule
