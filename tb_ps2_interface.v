`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   09:38:51 11/06/2019
// Design Name:   ps2
// Module Name:   G:/hazi/ps2_testbench.v
// Project Name:  hazi
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ps2
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ps2_interface_testbench;

	// Inputs
	reg ps2_clk;
	wire ps2_data;
	reg clk;
	reg rst;
	reg ack;

	// Outputs
	wire [7:0] dataout;
	wire valid_data;

	// Instantiate the Unit Under Test (UUT)
	ps2_interface uut (
		.ps2_clk(ps2_clk), 
		.ps2_data(ps2_data), 
		.clk(clk), 
		.rst(rst), 
		.dataout(dataout), 
		.valid_data(valid_data),
		.ack(ack)
	);

	initial begin
		// Initialize Inputs
		ps2_clk = 0;
		clk = 0;
		rst = 1;
		ack = 0;
		
		#200 rst = 0;
	end
	
	always #10
      clk = ~clk;
		
	always #200
		ps2_clk <= ~ps2_clk;

	//reg [15:0] data = 16'b1110_1010_1010_0111;
	reg [10:0] data = 11'b0_0111_0101_01;
	always @ (posedge ps2_clk)
		if (~rst)
			data <= {data[0], data[10:1]};
		
	assign	ps2_data = data[0];
	
	always@ (posedge valid_data)
	begin
		#101
			ack = 1;
		#20
			ack = 0;
	end	
	
endmodule
