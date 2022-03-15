`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:32:34 12/11/2019
// Design Name:   ram
// Module Name:   C:/pac_man/tb_ram.v
// Project Name:  pac_man
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ram
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_ram;

	// Inputs
	reg clk;
	reg [10:0] addr_vga;
	reg [10:0] addr_game_logic;
	reg wr_game_logic;
	reg rd_game_logic;
	reg [2:0] din_game_logic;

	// Outputs
	wire [2:0] dout_game_logic_par;
	wire [10:0] dout_game_logic_pac;

	// Instantiate the Unit Under Test (UUT)
	ram uut (
		.clk(clk), 
		.addr_vga(addr_vga), 
		.addr_game_logic(addr_game_logic), 
		.wr_game_logic(wr_game_logic), 
		.rd_game_logic(rd_game_logic), 
		.din_game_logic(din_game_logic), 
		.dout_game_logic_par(dout_game_logic_par), 
		.dout_game_logic_pac(dout_game_logic_pac)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		addr_vga = 0;
		addr_game_logic = 0;
		wr_game_logic = 0;
		rd_game_logic = 0;
		din_game_logic = 0;

		// Wait 100 ns for global reset to finish
		#100;
		
		#100 	addr_game_logic = 11'h000;
		#100	wr_game_logic = 1;
		#100	wr_game_logic = 0;
		#100	rd_game_logic = 1;
		#100	rd_game_logic = 0;
        
		// Add stimulus here

	end
	
		always #10
		clk <= ~clk;
      
endmodule

