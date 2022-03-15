`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:09:43 11/08/2019
// Design Name:   vga
// Module Name:   D:/FPGA_Spartan_6/ping_pong/tb_vga_interface.v
// Project Name:  ping_pong
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: vga
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_vga_interface;

	// Inputs
	reg clk;
	reg rst;


	wire hsync;
	wire vsync;
	wire [1:0] r;
	wire [1:0] g;
	wire [1:0] b;

	// Instantiate the Unit Under Test (UUT)
	vga uut (
		.clk(clk), 
		.rst(rst), 
		.hsync(hsync), 
		.vsync(vsync), 
		.r(r), 
		.g(g), 
		.b(b)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		//$readmemh("input.txt", mem);
		
		#200 rst = 0;
		
	end
		
	always #10
		clk = ~clk;
		/*
	//ps2	
	always #200
		ps2_clk <= ~ps2_clk;

	reg [15:0] data = 16'b1110_0111_0101_0111;
	always @ (posedge ps2_clk)
		if (~rst)
			data <= {1'b1, data[15:1]};
		
	assign	ps2_data = data[0];
	
	always@ (posedge valid_data)
	begin
		#101
			ack = 1;
		#20
			ack = 0;
	end			
		*/
	/*
	reg [7:0] real_input_data;
	
	always@(posedge clk)
	begin
		if(~rst)
			real_input_data <= mem[addr];
	end
	
	assign rgb = real_input_data[5:0];
	
		*/
      
endmodule

