`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:37:14 10/09/2019 
// Design Name: 
// Module Name:    cpld_if 
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
module cpld_if(
	input clk_i,
	input rst_i,
	
	input [7:0] led_i,
	input [3:0] dig0_i,
	input [3:0] dig1_i,
	
	output [7:0] sw_o,
	
	output reg cpld_clk_o,
	output cpld_rstn_o,
	output reg cpld_load_o,
	output reg cpld_mosi_o,
	input cpld_miso_i,
	output cpld_jtagen_o
    );

assign cpld_jtagen_o = 1'b0;
assign cpld_rstn_o = ~rst_i;   //cpld negált resetet vár

reg [15:0] cntr;
always @ (posedge clk_i)
if(rst_i)
	cntr <= 0;
else
	cntr <= cntr + 1;

wire cpld_clk;
assign cpld_clk = cntr[10];

wire cpld_clk_fall;
assign cpld_clk_fall = (cntr[10:0] == 11'b11111111111);

wire [3:0] bit_cntr;
assign bit_cntr = cntr[14:11];

wire cpld_load;
assign cpld_load = (bit_cntr == 15);

wire dig_sel;
assign dig_sel = cntr[15];

reg [15:0] dreg;
always @ (posedge clk_i)
if(cpld_clk_fall == 1'b1 & cpld_load == 1'b1)
	dreg <= {dig1_i,dig0_i,led_i};
	
wire [3:0] dig_mux;
assign dig_mux = (dig_sel == 1'b1) ? dreg[11:8] : dreg[15:12];


// 7-segment encoding
//      0
//     ---
//  5 |   | 1
//     --- <--6
//  4 |   | 2
//     ---
//      3

reg [7:0] seg_dec;
always @ ( * )//bármelyik bemenet változik , mindegy hogy blokkoló vagy nem értékadás , a 8. helyén 1 = nincs pont
      case (dig_mux)
          4'b0001 : seg_dec = 8'b11111001;   // 1
          4'b0010 : seg_dec = 8'b10100100;   // 2
          4'b0011 : seg_dec = 8'b10110000;   // 3
          4'b0100 : seg_dec = 8'b10011001;   // 4
          4'b0101 : seg_dec = 8'b10010010;   // 5
          4'b0110 : seg_dec = 8'b10000010;   // 6
          4'b0111 : seg_dec = 8'b11111000;   // 7
          4'b1000 : seg_dec = 8'b10000000;   // 8
          4'b1001 : seg_dec = 8'b10010000;   // 9
          4'b1010 : seg_dec = 8'b10001000;   // A
          4'b1011 : seg_dec = 8'b10000011;   // b
          4'b1100 : seg_dec = 8'b11000110;   // C
          4'b1101 : seg_dec = 8'b10100001;   // d
          4'b1110 : seg_dec = 8'b10000110;   // E
          4'b1111 : seg_dec = 8'b10001110;   // F
          default : seg_dec = 8'b11000000;   // 0
      endcase
				
wire [15:0] mosi_mux;
assign mosi_mux = {~seg_dec,dreg[7:0]}; //seg_dec negáltan

wire cpld_mosi;
assign cpld_mosi = mosi_mux[bit_cntr];

always @ (posedge clk_i)
begin
	cpld_clk_o <= cpld_clk;    //DFF
	cpld_load_o <= cpld_load;	//DFF
	cpld_mosi_o <= cpld_mosi;	//DFF
end

reg [15:0] shr;
reg[15:0] dout_reg;

always @ (posedge clk_i)
if(cpld_clk_fall)
	shr <= {cpld_miso_i,shr[15:1]};
	
always @ (posedge clk_i)
if(cpld_clk_fall & cpld_load)
	dout_reg <= shr;
	
assign sw_o = dout_reg[7:0];

endmodule
