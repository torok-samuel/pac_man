`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:42:22 11/20/2019 
// Design Name: 
// Module Name:    top_level_vga 
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
module top_level_vga(
	input clk,
	input rst_n,

	//vga
	
	output hsync,
	output vsync,
	output [1:0] r,
	output [1:0] g,
	output [1:0] b,
	
	
	//cpld
	input cpld_miso_i,
	
	output cpld_clk_o,
	output cpld_rstn_o,
	output cpld_load_o,
	output cpld_mosi_o,
	output cpld_jtagen_o,
	
	//ps2
	input ps2_clk,
	input ps2_data,
	output ack,
	
	//game_logic				
	output [7:0] state_led_o
	
	//ram
	
    );


wire [10:0] addr_ram;

wire [2:0] dout_vga;
wire [2:0] dout_game_logic_par;
wire [10:0] dout_game_logic_pac;

//wire ack;

wire [2:0] poz_par_o;
wire wr_b_o;
wire rd_en_o;
wire [10:0] next_poz_o;
wire [4:0] pontok_count_o;


wire rst;
assign rst = ~rst_n;

wire clk_o;

reg clk_div;
always @ (posedge clk)
	clk_div <= ~clk_div;
	
BUFG BUFG_inst (
      .O(clk_o),
      .I(clk_div)
   );


	
//wire rst;
//assign rst = ~rstn_i; //hogy ponált legyen ezért negálunk

wire [7:0] sw;
wire [7:0] data;

wire valid_data;
	
	
	
//vga
vga vga_peldanyositva (
	.clk(clk_o), 
	.rst(rst),  
	.hsync(hsync), 
	.vsync(vsync),
	.ram_dout(dout_vga),
	.addr_ram(addr_ram),
	.r(r), 
	.g(g), 
	.b(b),
	.blank_start(blank_start)
    );
	 	

//cpld_if ps2-vel	
	cpld_if cpld_if_i (
		.clk_i(clk), 
		.rst_i(rst), 
		.led_i(data),						//data[7:0]), 
		.dig0_i(pontok_count_o[3:0]),
		.dig1_i(pontok_count_o[4]),
		.sw_o(sw),
		.cpld_clk_o(cpld_clk_o), 
		.cpld_rstn_o(cpld_rstn_o), 
		.cpld_load_o(cpld_load_o), 
		.cpld_mosi_o(cpld_mosi_o), 
		.cpld_miso_i(cpld_miso_i),
		.cpld_jtagen_o(cpld_jtagen_o)
	);

ps2_interface ps2 (
    .ps2_clk(ps2_clk), 
    .ps2_data(ps2_data), 
    .clk(clk), 
    .rst(rst), 
    .dataout(data), 
    .valid_data(valid_data), 
    .ack(ack)
    );

game_logic game_log(
		.ack_o(ack),
		.clk(clk),
		.rst(rst),
		.ps2_valid(valid_data),
		.ps2_data(data),
		.blank_start(blank_start),

		.poz_par_i(dout_game_logic_par),
		
		.pontok_count_o(pontok_count_o),
		
		.poz_par_o(poz_par_o),
		.wr_b_o(wr_b_o),
		.rd_en_o(rd_en_o),
		.next_poz_o(next_poz_o),
		
		.state_led_o(state_led_o)
    );
	 
	 

ram ram_peldanyositva(
	.clk(clk),
	.addr_vga(addr_ram),			//vga
	.addr_game_logic(next_poz_o),

	.wr_game_logic(wr_b_o),
	.rd_game_logic(rd_en_o),
	
	.din_game_logic(poz_par_o),
	
	.dout_vga(dout_vga),			//vga 
	.dout_game_logic_par(dout_game_logic_par)
);


endmodule
