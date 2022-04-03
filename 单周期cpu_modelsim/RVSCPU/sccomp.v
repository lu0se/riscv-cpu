module sccomp(clk, rstn, reg_sel, reg_data);
   input          clk;
   input          rstn;
   input [4:0]    reg_sel;
   output [31:0]  reg_data;
   
   wire [31:0]    instr;
   wire [31:0]    PC;
   wire           MemWrite;
   wire [31:0]    dm_addr, dm_din, dm_dout;
   wire [3:0]   ls;       
   
   wire rst = ~rstn;
       
  // instantiation of single-cycle CPU   
   sccpu U_SCPU(
         .clk(clk),                 // input:  cpu clock
         .rst(rst),                 // input:  reset
         .instr(instr),             // input:  instruction
         .readdata(dm_dout),        // input:  data to cpu  
         .MemWrite(MemWrite),       // output: memory write signal
         .PC(PC),                   // output: PC
         .aluout(dm_addr),          // output: address from cpu to memory
         .writedata(dm_din),        // output: data from cpu to memory
         .reg_sel(reg_sel),         // input:  register selection
         .reg_data(reg_data),       // output: register data
	 .ls(ls)    		    // output: load and write type whb
         );
         
  // instantiation of data memory  
   dm    U_DM(
         .clk(clk),           // input:  cpu clock
         .DMWr(MemWrite),     // input:  ram write
         .addr(dm_addr),      // input:  ram address
         .din(dm_din),        // input:  data to ram
	 .ls(ls),             // input:  load and write type whb
         .dout(dm_dout)       // output: data from ram
         );
         
  // instantiation of intruction memory (used for simulation)
   im    U_IM ( 
      .addr(PC[31:2]),     // input:  rom address
      .dout(instr)        // output: instruction
   );
        
endmodule

