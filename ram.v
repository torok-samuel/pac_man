`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:54:17 11/12/2019 
// Design Name: 
// Module Name:    ram 
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
module ram(
	input clk,
	input [10:0] addr_vga,
	input [10:0] addr_game_logic,
	
	input wr_game_logic,
	input rd_game_logic,
	
	input [2:0] din_game_logic,
	
	output reg [2:0] dout_vga,
	output reg [2:0] dout_game_logic_par
    );

reg [2:0] mem[1199:0];
initial	$readmemb("palya.txt", mem);
reg [10:0] dout_delay;

always@(posedge clk)
		dout_vga <= mem[addr_vga];

always@(posedge clk)
begin
	if(wr_game_logic)
		mem[addr_game_logic] <= din_game_logic;
	else if(rd_game_logic)
		dout_game_logic_par <= mem[addr_game_logic];
end

endmodule
