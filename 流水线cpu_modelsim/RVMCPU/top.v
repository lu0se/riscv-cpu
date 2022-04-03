`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:36:48 06/29/2021 
// Design Name: 
// Module Name:    top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module top(input RSTN,
			  input [3:0] BTN_y,
			  input [15:0] SW,
			  input clk_100mhz,
			  output CR,
			  output seg_clk,
			  output seg_sout,
			  output SEG_PEN,
			  output seg_clrn,
			  output led_clk,
			  output led_sout,
			  output LED_PEN,
			  output led_clrn,
			  output RDY,
			  output readn,
			  output [4:0] BTN_x);
	wire [4:0] Key_out;
	wire rst;
	wire [3:0] Pulse,BTN_OK;
	wire [15:0] SW_OK,LED_out;
	wire [1:0]  counter_ch;
	wire [31:0] Div,Ai,Bi,Disp_num,inst,PC,Addr_out,Data_in,Data_out,ram_data_in,ram_data_out,CPU2IO,Counter_out;
	wire Clk_CPU,counter0_out,counter1_out,counter_we,mem_w,data_ram_we,MultiEN,GPIOF0;
	wire [7:0] LE_out,point_out,blink;
	wire [9:0] ram_addr;
	wire V5,N0;
	
	assign V5=1;
	assign N0=0;
	SAnti_jitter U9(
		.clk(clk_100mhz),
		.RSTN(RSTN),
		.Key_y(BTN_y[3:0]),
		.Key_x(BTN_x[4:0]),
		.SW(SW[15:0]),
		.readn(readn),
		.CR(CR),
		.Key_out(Key_out[4:0]),
		.Key_ready(RDY),
		.pulse_out(Pulse[3:0]),
		.BTN_OK(BTN_OK[3:0]),
		.SW_OK(SW_OK[15:0]),
		.rst(rst)
		);
	clk_div U8(
		.clk(clk_100mhz),
		.rst(rst),
		.SW2(SW_OK[2]),
		.clkdiv(Div[31:0]),
		.Clk_CPU(Clk_CPU)
		);
	SEnter_2_32 M4(
		.clk(clk_100mhz),
		.Din(Key_out[4:0]),
		.D_ready(RDY),
		.BTN(BTN_OK[2:0]),
		.Ctrl({SW_OK[7:5],SW_OK[15],SW_OK[0]}),
		.readn(readn),
		.Ai(Ai[31:0]),
		.Bi(Bi[31:0]),
		.blink(blink[7:0])
		);
	SSeg7_Dev U6(
		.clk(clk_100mhz),
		.rst(rst),
		.Start(Div[20]),
		.SW0(SW_OK[0]),
		.flash(Div[25]),
		.Hexs(Disp_num[31:0]),
		.point(point_out[7:0]),
		.LES(LE_out[7:0]),
		.seg_clk(seg_clk),
		.seg_sout(seg_sout),
		.SEG_PEN(SEG_PEN),
		.seg_clrn(seg_clrn)
		);
	sccpu U1( 
		.clk(Clk_CPU), 
      .rst(rst), 
		.instr(inst), 
		.readdata(Data_in), 
		.PC(PC), 
		.MemWrite(mem_w), 
		.aluout(Addr_out), 
		.writedata(Data_out), 
		.reg_sel(), 
		.reg_data(),
		.ls()
		);
	MIO_BUS U4(
		.clk(clk_100mhz), 
		.rst(rst), 
		.BTN(BTN_OK[3:0]),
		.SW(SW_OK[15:0]),
		.mem_w(mem_w),
		.addr_bus(Addr_out[31:0]),
		.Cpu_data4bus(Data_in[31:0]),
		.Cpu_data2bus(Data_out[31:0]),
		.ram_data_in(ram_data_in[31:0]),
		.data_ram_we(data_ram_we),
		.ram_addr(ram_addr[9:0]),
		.ram_data_out(ram_data_out[31:0]),
		.Peripheral_in(CPU2IO[31:0]),
		.GPIOe0000000_we(MultiEN),
		.GPIOf0000000_we(GPIOF0),
		.led_out(LED_out[15:0]),
		.counter_out(Counter_out[31:0]),
		.counter2_out(counter2_out),
		.counter1_out(counter1_out),
		.counter0_out(counter0_out),
		.counter_we(counter_we)
		);
	Counter_x U10(
		.clk(~Clk_CPU),
		.rst(rst),
		.clk0(Div[6]),
		.clk1(Div[9]),
		.clk2(Div[11]),
		.counter_we(counter_we),
		.counter_val(CPU2IO[31:0]),
		.counter_ch(counter_ch[1:0]),
		.counter0_OUT(counter0_out),
		.counter1_OUT(counter1_out),
		.counter2_OUT(counter2_out),
		.counter_out(Counter_out[31:0])
		);
	Multi_8CH32  U5(
		.clk(~Clk_CPU), 
		.rst(rst),
		.EN(MultiEN), 
		.Test(SW_OK[7:5]), 
		.point_in({Div[31:0], Div[31:0]}), 
		.LES({64{1'b0}}),
      .Data0(CPU2IO[31:0]), 
      .data1({N0,N0,PC[31:2]}), 
      .data2(inst[31:0]), 
      .data3(Counter_out[31:0]), 
      .data4(Addr_out[31:0]), 
      .data5(Data_out[31:0]), 
		.data6(Data_in[31:0]), 
		.data7(PC[31:0]),
		.Disp_num(Disp_num[31:0]), 
      .LE_out(LE_out[7:0]), 
      .point_out(point_out[7:0])
		);
	SPIO  U7(
		.clk(~Clk_CPU), 
		.rst(rst), 
		.EN(GPIOF0),  
		.Start(Div[20]),
		.P_Data(CPU2IO[31:0]), 
		.counter_set(counter_ch),
		.LED_out(LED_out[15:0]),		
		.GPIOf0(), 
		.led_clk(led_clk), 
		.led_sout(led_sout),
		.LED_PEN(LED_PEN),
		.led_clrn(led_clrn)   
		);
	ROM_D  U2 (
		.a(PC[11:2]), 
		.spo(inst[31:0])
		);
   RAM_B  U3 (
		.addra(ram_addr[9:0]), 
      .wea(data_ram_we),
		.dina(ram_data_in[31:0]),
      .clka(~clk_100mhz), 
      .douta(ram_data_out[31:0])
		);
endmodule
