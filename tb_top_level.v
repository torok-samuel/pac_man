`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:36:25 12/12/2019
// Design Name:   top_level
// Module Name:   C:/pac_man/tb_top_level.v
// Project Name:  pac_man
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: top_level
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_top_level;

	// Inputs
	reg clk;
	reg rst_n;
	reg cpld_miso_i;
	reg ps2_clk;
	reg ps2_data;

	// Outputs
	wire hsync;
	wire vsync;
	wire [1:0] r;
	wire [1:0] g;
	wire [1:0] b;
	wire cpld_clk_o;
	wire cpld_rstn_o;
	wire cpld_load_o;
	wire cpld_mosi_o;
	wire cpld_jtagen_o;
	wire [7:0] state_led_o;

	// Instantiate the Unit Under Test (UUT)
	top_level uut (
		.clk(clk), 
		.rst_n(rst_n), 
		.hsync(hsync), 
		.vsync(vsync), 
		.r(r), 
		.g(g), 
		.b(b), 
		.cpld_miso_i(cpld_miso_i), 
		.cpld_clk_o(cpld_clk_o), 
		.cpld_rstn_o(cpld_rstn_o), 
		.cpld_load_o(cpld_load_o), 
		.cpld_mosi_o(cpld_mosi_o), 
		.cpld_jtagen_o(cpld_jtagen_o), 
		.ps2_clk(ps2_clk), 
		.ps2_data(ps2_data), 
		.state_led_o(state_led_o)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst_n = 0;
		cpld_miso_i = 0;
		ps2_clk = 0;
		rst_n = 0;
		ps2_data = 0;

		// Wait 100 ns for global reset to finish
		#100;
		#100 rst_n = 1;
		
		end
			
	always #10
      clk = ~clk;
		
	always #200
		ps2_clk <= ~ps2_clk;

	//reg [15:0] data = 16'b1110_1010_1010_0111;
	reg [10:0] data_i = 11'b0_0111_0101_01;
	
	always @ (posedge ps2_clk)
		if (rst_n)
		begin
			data_i <= {data_i[0], data_i[10:1]};
			ps2_data = data_i[0];
		end


        
		// Add stimulus here


      
endmodule

