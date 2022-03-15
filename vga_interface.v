`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:27:39 11/05/2019 
// Design Name: 
// Module Name:    vga 
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
module vga(
	input clk,
	input rst,
	input [2:0] ram_dout,
	
	output [10:0] addr_ram,
	output hsync,
	output vsync,
	output [1:0] r,
	output [1:0] g,
	output [1:0] b,
	output blank_start
);


reg [5:0] rgb_o; 


reg [9:0] hcntr;

always@(posedge clk)
begin
	if(rst | hcntr == 799)
		hcntr <= 0;
	else
		hcntr <= hcntr + 1;
end

reg act_hcntr;

always@(posedge clk)
begin
	if(hcntr == 799 )
		act_hcntr <= 1;
	else if(hcntr == 639)
		act_hcntr <= 0;
end

reg [9:0] vcntr;

always@(posedge clk)
begin
	if(rst)
		vcntr <= 0;
	else if (hcntr == 799)
		if(vcntr == 520)
			vcntr <= 0;
		else
			vcntr <= vcntr + 1;
end

reg act_vcntr;

always@(posedge clk)
begin
	if (hcntr == 799)
		if(vcntr == 520)
			act_vcntr <= 1;
		else if(vcntr == 479)
			act_vcntr <= 0;
end

				//wire [10:0] addr_ram;
//assign addr_ram = {vcntr[8:4],hcntr[9:4]};
assign addr_ram = vcntr[8:4]*40+hcntr[9:4];

reg act_dl;
reg act_dl_2;

always@ (posedge clk)
begin
	act_dl <= act_hcntr & act_vcntr;
	act_dl_2 <= act_dl;
end

assign blank_start = ~act_dl_2;

wire [5:0] rgb;
always@(posedge clk)
begin
	if(act_dl_2)
		rgb_o <= rgb;
	else
		rgb_o <= 0;
end



assign r = rgb_o[5:4];		//[1:0];
assign g = rgb_o[3:2];		//[3:2];
assign b = rgb_o[1:0];		//[5:4];

reg hsync_copy;

always@(posedge clk)
begin
	if(rst | hcntr == 751)
		hsync_copy <= 0;
	else if( hcntr == 655)
		hsync_copy <= 1;
end

reg vsync_copy;

always@(posedge clk)
begin
	if (hcntr == 799)
		if(vcntr == 493)
			vsync_copy <= 1;
		else if(vcntr == 491)
			vsync_copy <= 0;
end		

assign vsync = ~vsync_copy;
assign hsync = ~hsync_copy;
//innen kezdtem írni
reg [5:0]  pontok[255:0];
initial	$readmemh("pontok.txt", pontok);

reg [5:0]  UT[255:0];
initial	$readmemh("UT.txt", UT);

reg [5:0]  fal[255:0];
initial	$readmemh("fal.txt", fal);

reg [5:0]  nagypontok[255:0];
initial	$readmemh("nagypontok.txt", nagypontok);

reg [5:0]  felfal[255:0];
initial	$readmemh("felfal.txt", felfal);

reg [5:0]  pac_man[255:0];
initial	$readmemh("pac_man_right.txt", pac_man);

wire [10:0] palyaparcellatoltes_copy;

assign palyaparcellatoltes_copy = {ram_dout[2:0], vcntr[3:0], hcntr[3:0]};


wire [10:0] palyaparcellatoltes;
assign palyaparcellatoltes = palyaparcellatoltes_copy;


wire [5:0] pac_man_out;
wire [5:0] pontok_out;
wire [5:0] UT_out;
wire [5:0] fal_out;
wire [5:0] nagypontok_out;
wire [5:0] felfal_out;
assign pac_man_out = pac_man[palyaparcellatoltes[7:0]];
assign pontok_out = pontok[palyaparcellatoltes[7:0]];
assign UT_out = UT[palyaparcellatoltes[7:0]];
assign fal_out = fal[palyaparcellatoltes[7:0]];
assign nagypontok_out = nagypontok[palyaparcellatoltes[7:0]];
assign felfal_out = felfal[palyaparcellatoltes[7:0]];

reg [5:0] rgb_toltes;
reg [10:0] pac_poz;
always@ (posedge clk)
begin
	case(palyaparcellatoltes[10:8])
		3'b101 : rgb_toltes <= pontok_out;
		3'b100 : rgb_toltes <= UT_out;
		3'b000 : rgb_toltes <= fal_out;
		3'b110 : rgb_toltes <= nagypontok_out;
		3'b001 : rgb_toltes <= felfal_out;
		3'b010 : rgb_toltes <= pac_man_out;
		default : rgb_toltes <= fal_out;
	endcase
end
/*
always@ (posedge clk)
begin
	//if(palyaparcellatoltes[10:8] == 3'b010)
			 pac_poz <= 11'b00000000000; 			//addr_ram;
end
*/
assign rgb = rgb_toltes;

				//wire [2:0] ram_dout;


//ram
/*
ram ram_peldanyositva(
	.clk(clk),
	.addr_a(addr_ram),
	
	.dout_a(ram_dout)			//rgb 
);
*/
endmodule
