`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:40:06 11/27/2019 
// Design Name: 
// Module Name:    testbench 
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
module testbench;

	//inputs
	reg clk;
	reg rst_n;
	
	//outputs
	reg hsync;
	reg vsync;
	
	reg [1:0] r;
	reg [1:0] g;
	reg [1:0] b;
   


	top_level_vga vga(
	.clk,
	.rst_n,

	.hsync,
	.vsync,
	.[1:0] r,
	.[1:0] g,
	.[1:0] b
    );
	 
	 initial begin
	 

	end

endmodule
