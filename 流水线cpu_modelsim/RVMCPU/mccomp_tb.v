
// testbench for simulation
module mccomp_tb();
    
   reg  clk, rstn;
   reg  [4:0] reg_sel;
   wire [31:0] reg_data;
    
// instantiation of sccomp    
   mccomp U_MCCOMP(
      .clk(clk), .rstn(rstn), .reg_sel(reg_sel), .reg_data(reg_data) 
   );

  	integer foutput;
  	integer counter = 0;
	integer i;
   
   initial begin
      $readmemh( "C:/Users/Administrator/Desktop/RVSCPU/riscv32_simm.txt" , U_MCCOMP.U_IM.ROM); // load instructions into instruction memory
      $readmemh( "C:/Users/Administrator/Desktop/RVSCPU/d.dat" , U_MCCOMP.U_DM.dmem);
//    $monitor("PC = 0x%8X, instr = 0x%8X", U_MCCOMP.PC, U_MCCOMP.instr); // used for debug
      foutput = $fopen("results.txt");
      clk = 1;
      rstn = 1;
      #5 ;
      rstn = 0;
      #20 ;
      rstn = 1;
      #1000 ;
      reg_sel = 7;
   end
   
    always begin
    #(50) clk = ~clk;
	   
    if (clk == 1'b1) begin
      if ((counter == 1000) ) begin
	  counter = counter + 1;
          $fdisplay(foutput, "pc:\t %h", U_MCCOMP.PC);
          $fdisplay(foutput, "num:\t %h", U_MCCOMP.PC[31:2]);
          $fdisplay(foutput, "instr:\t\t %h", U_MCCOMP.instr);
          $fdisplay(foutput, "rf00-03:\t %h %h %h %h", 0, U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[1], U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[2], U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[3]);
          $fdisplay(foutput, "rf04-07:\t %h %h %h %h", U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[4], U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[5], U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[6], U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[7]);
          $fdisplay(foutput, "rf08-11:\t %h %h %h %h", U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[8], U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[9], U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[10], U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[11]);
          $fdisplay(foutput, "rf12-15:\t %h %h %h %h", U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[12], U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[13], U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[14], U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[15]);
          $fdisplay(foutput, "rf16-19:\t %h %h %h %h", U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[16], U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[17], U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[18], U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[19]);
          $fdisplay(foutput, "rf20-23:\t %h %h %h %h", U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[20], U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[21], U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[22], U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[23]);
          $fdisplay(foutput, "rf24-27:\t %h %h %h %h", U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[24], U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[25], U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[26], U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[27]);
          $fdisplay(foutput, "rf28-31:\t %h %h %h %h", U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[28], U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[29], U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[30], U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[31]); 
	  $fdisplay(foutput,"memory[0]:\t %h %h %h %h",U_MCCOMP.U_DM.dmem[3],U_MCCOMP.U_DM.dmem[2],U_MCCOMP.U_DM.dmem[1],U_MCCOMP.U_DM.dmem[0]);
          $fdisplay(foutput,"memory[12]:\t %h %h %h %h",U_MCCOMP.U_DM.dmem[15],U_MCCOMP.U_DM.dmem[14],U_MCCOMP.U_DM.dmem[13],U_MCCOMP.U_DM.dmem[12]);
          $fclose(foutput);
          $stop;
      end
      else begin 
          counter = counter + 1;
          $fdisplay(foutput, "pc:\t %h", U_MCCOMP.PC);
           $fdisplay(foutput, "num:\t %h", U_MCCOMP.PC[31:2]);
          $fdisplay(foutput, "instr:\t\t %h", U_MCCOMP.instr);
          $fdisplay(foutput, "rf00-03:\t %h %h %h %h", 0, U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[1], U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[2], U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[3]);
          $fdisplay(foutput, "rf04-07:\t %h %h %h %h", U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[4], U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[5], U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[6], U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[7]);
          $fdisplay(foutput, "rf08-11:\t %h %h %h %h", U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[8], U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[9], U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[10], U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[11]);
          $fdisplay(foutput, "rf12-15:\t %h %h %h %h", U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[12], U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[13], U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[14], U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[15]);
          $fdisplay(foutput, "rf16-19:\t %h %h %h %h", U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[16], U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[17], U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[18], U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[19]);
          $fdisplay(foutput, "rf20-23:\t %h %h %h %h", U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[20], U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[21], U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[22], U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[23]);
          $fdisplay(foutput, "rf24-27:\t %h %h %h %h", U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[24], U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[25], U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[26], U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[27]);
          $fdisplay(foutput, "rf28-31:\t %h %h %h %h", U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[28], U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[29], U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[30], U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf[31]);
          $fdisplay(foutput,"memory[0]:\t %h %h %h %h",U_MCCOMP.U_DM.dmem[3],U_MCCOMP.U_DM.dmem[2],U_MCCOMP.U_DM.dmem[1],U_MCCOMP.U_DM.dmem[0]);
          $fdisplay(foutput,"memory[12]:\t %h %h %h %h",U_MCCOMP.U_DM.dmem[15],U_MCCOMP.U_DM.dmem[14],U_MCCOMP.U_DM.dmem[13],U_MCCOMP.U_DM.dmem[12]);
          //$fdisplay(foutput, "hi lo:\t %h %h", U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf.hi, U_MCCOMP.U_MCPU.U_pipeid.U_RF.rf.lo);
          //$fclose(foutput);
      end
    end
  end //end always
   
endmodule
