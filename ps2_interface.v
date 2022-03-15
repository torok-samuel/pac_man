`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:32:55 11/05/2019 
// Design Name: 
// Module Name:    ps2_interface 
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

module ps2_interface(
	input ps2_clk,
	input ps2_data,
	input clk,
	input rst,
	
	output [7:0] dataout,
	output valid_data,
	
	input ack
	
	
	//input ack
    );

reg [1:0] ps2_clk_next_state;

always@ (posedge clk)
begin
		ps2_clk_next_state <= {ps2_clk_next_state[0],ps2_clk};
end

reg ps2_clk_fall;

always@(posedge clk)
begin
	if(ps2_clk_next_state==2'b10)
		ps2_clk_fall <= 1;
	else
		ps2_clk_fall <= 0;
end

reg state; //state==0 ha idle state==1 ha rx

always @ (posedge clk)
begin
	if(rst)
		state <=0;
	else if(ps2_clk_fall == 1 & state == 0 & ps2_data == 0) //rx feltétel
		state <= 1;
	else if(ps2_clk_fall == 1 & ps2_data == 1 & state == 1 & cntr == 9) //idle feltétel
		state <= 0;
end

reg [3:0] cntr;

always@(posedge clk)
begin
	if(ps2_clk_fall == 1 & state == 0 & ps2_data == 0) 
		cntr <= 0;
	else if(ps2_clk_fall == 1 & state == 1) 
		cntr <= cntr + 1;
		
end

reg en_shift;

always@(posedge clk)
begin
	if(ps2_clk_fall == 1 & state == 0 & ps2_data == 0)
		en_shift <= 1;
	else if(cntr==7 & ps2_clk_fall==1)
		en_shift <= 0;
end
	

reg [7:0] shift_reg;

always@(posedge clk)
begin
	if(en_shift & ps2_clk_fall)
		shift_reg <= {ps2_data, shift_reg[7:1]};
end



reg [7:0] dataout_copy;

//assign valid_data = ~en_shift;  //ha nem shiftelünk akkor valid

always@(posedge clk)
begin
	if(cntr == 8 & state == 1)
		dataout_copy <= shift_reg;
end

assign dataout = dataout_copy;

reg valid_data_copy;

always@ (posedge clk)
begin
	if(rst)
		valid_data_copy <= 0;
	else if(ps2_clk_fall == 1 & cntr == 9 & state == 1)
		valid_data_copy <= 1;
	else if(ack)
		valid_data_copy <= 0;
end

assign valid_data = valid_data_copy;

endmodule
