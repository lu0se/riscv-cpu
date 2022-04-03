module PC(clk,
          rst,
          write_enable,
          NPC,
          PC);
    
    input              clk;
    input              rst;
    input              write_enable;
    input       [31:0] NPC;
    output reg  [31:0] PC;
    
    always @(negedge clk, posedge rst)
        if (rst)
            PC         <= 32'h0000_0000;
            //      PC <= 32'h0000_3000;
        else if(write_enable)
            PC <= NPC;
endmodule
    
