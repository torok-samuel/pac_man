`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:09:09 12/10/2019
// Design Name:   game_logic
// Module Name:   C:/pac_man/tb_game_logic.v
// Project Name:  pac_man
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: game_logic
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_game_logic;

	// Inputs
	reg clk;
	reg rst;
	reg ps2_valid;
	reg [7:0] ps2_data;
	reg blank_start;
	reg [2:0] poz_par_i;

	// Outputs
	wire [2:0] poz_par_o;
	wire wr_b_o;
	wire en_rd_o;
	wire [10:0] next_poz_o;
	wire [4:0] pontok_count_o;
	wire [7:0] state_led_o;

	// Instantiate the Unit Under Test (UUT)
	game_logic uut (
		.clk(clk),
		.rst(rst),
		.ps2_valid(ps2_valid), 
		.ps2_data(ps2_data), 
		.blank_start(blank_start), 
		.poz_par_i(poz_par_i),  
		.pontok_count_o(pontok_count_o), 
		.poz_par_o(poz_par_o),	 
		.wr_b_o(wr_b_o),
		.rd_en_o(rd_en_o),
		.next_poz_o(next_poz_o),
		.state_led_o(state_led_o)
		
	);
	
	reg [2:0] mem[1199:0];
	reg [10:0] pac_poz;

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		ps2_valid = 0;
		ps2_data = 0;
		blank_start = 0;
		//poz_par_i = 0;
		pac_poz = 11'b01110000100;
		$readmemb("palya.txt", mem);


		// Wait 100 ns for global reset to finish
		#100 rst = 0;
        
		// Add stimulus here
		#100 ps2_data = 8'h74;				//8'h75<-- mûködik
		#100 ps2_valid = 1;
		#100 blank_start = 1;


	end
	
	//always @ (posedge clk)
	//poz_par_i <= mem[poz_o];

	
	
	
	always @ (posedge clk)
	begin
	if(wr_b_o)
		mem[next_poz_o] <= 	poz_par_o;					//pac_poz <= poz_o;
	if(rd_en_o)
		poz_par_i <= mem[next_poz_o];
	end
	
	always #10
		clk <= ~clk;
      
endmodule

