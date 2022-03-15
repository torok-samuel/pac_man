`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:08:48 12/04/2019 
// Design Name: 
// Module Name:    game_logic 
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
module game_logic(
		input clk,
		input rst,
		input ps2_valid,
		input [7:0] ps2_data,
		input blank_start,
		
		input [2:0] poz_par_i,
		//input [10:0] pac_poz,
		
		
		output [4:0] pontok_count_o,
		
		output ack_o,
		output [2:0] poz_par_o,
		output wr_b_o,
		output rd_en_o,
		output [10:0] next_poz_o,
		//output [10:0] pac_poz_o,
		output [7:0] state_led_o
    );

reg [4:0] State;
parameter idle = 5'b00000;
parameter check_ps2 = 5'b00001;
parameter mov_pac_memrd_addr = 5'b00010;
parameter mov_pac_next_direction	= 5'b00011;
parameter mov_pac_next_poz = 5'b00100;
parameter mov_pac_check = 5'b00101;
parameter mov_pac_last_direction = 5'b00110;
parameter mov_pac_last_check = 5'b00111;
//parameter mov_pac_write = 5'b01000;
parameter mov_ghost1 = 5'b01001;
parameter vege = 5'b01010;
parameter mov_pac_last_write = 5'b01011;
parameter mov_pac_memrd_addr2 = 5'b01100;
parameter mov_pac_write_1 = 5'b01101;
parameter mov_pac_write_1_d = 5'b01110;
parameter mov_pac_write_2 = 5'b01111;
parameter mov_pac_write_2_d = 5'b10000;
parameter mov_pac_last_write_1 = 5'b10001;
parameter mov_pac_last_write_1_d = 5'b10010;
parameter mov_pac_last_write_2 = 5'b10011;
parameter mov_pac_last_write_2_d = 5'b10100;
parameter ack1 = 5'b10101;
parameter ack2 = 5'b10110;


reg ack;
reg [1:0] next_direction;
reg [1:0] last_direction;
reg [10:0] next_poz;
reg [2:0] poz_par;
reg [4:0] pontok_count;
reg wr_b;
reg [7:0] state_led;
reg rd_en;
reg [10:0] pac_poz;


always @ (posedge clk)
begin
if(rst)
	begin
			ack <= 0;
			State <= idle;
			wr_b <= 0;
			pac_poz <= 11'b01110000100;
			pontok_count <= 5'b0;
	end
	
else
	case(State)
	idle :							////000000
			if(ps2_valid)
					if(blank_start)
					begin
						State <= check_ps2;
						wr_b <= 0;
						state_led <= 8'b00000001;
					end
						
	check_ps2 :					////00001
	begin
		if(ps2_valid)
			State <= mov_pac_next_direction;
		else
			State <= mov_ghost1;
		state_led <= 8'b00000010;
	end
			
	mov_pac_next_direction :			////00011
	begin		
			rd_en <= 1;
			case(last_direction)
				2'b00 : last_direction <= 2'b00;
				2'b01 : last_direction <= 2'b01;
				2'b10 : last_direction <= 2'b10;
				2'b11 : last_direction <= 2'b11;
				default: last_direction <= 2'b01;
			endcase			
			case(ps2_data)
				8'h75 : next_direction <= 2'b00;		//Up
				8'hD5 : next_direction <= 2'b00;
				8'h1D : next_direction <= 2'b00;		//W
				8'hAC : next_direction <= 2'b00;
				8'h6B : next_direction <= 2'b01;		//Left
				8'hF0 : next_direction <= 2'b01;
				8'h1C : next_direction <= 2'b01;		//A
				8'h8C : next_direction <= 2'b01;
				8'h72 : next_direction <= 2'b10;		//Down
				8'hC9 : next_direction <= 2'b10;
				8'h1B : next_direction <= 2'b10;					//S
				8'h74 : next_direction <= 2'b11;		//Right
				8'hD1 : next_direction <= 2'b11;
				8'h23 : next_direction <= 2'b11;					//D
				default : next_direction <= last_direction;
			endcase
		State <= mov_pac_next_poz;
		state_led <= 8'b00000011;
	end

	mov_pac_next_poz:				/////00100
	begin
	rd_en <= 1;
			case(next_direction)
				2'b00 : next_poz <= pac_poz - 10'b0000101000;		//up		+2h'28
				2'b01 : next_poz <= pac_poz - 10'b0000000001;		//left		//10'b0000011110;	+2h'1E
				2'b10 : next_poz <= pac_poz + 10'b0000101000;		//down	-2h'28
				2'b11 : next_poz <= pac_poz + 10'b0000000001;		//right	//10'b0000011110; -2h'1E
				default : next_poz <= pac_poz - 10'b0000011110;
			endcase
			state_led <= 8'b00000100;
	State <= mov_pac_memrd_addr;				//memread?
	end

	mov_pac_memrd_addr:				//00010
	State <= mov_pac_check;

	mov_pac_check:						///00101
	begin
	rd_en <= 0;
			state_led <= 8'b00000101;
			if(poz_par_i == 3'b000 | poz_par_i == 3'b001)		//falba ütközik
					State <= mov_pac_last_direction;
			else if(poz_par_i == 3'b101 | poz_par_i == 3'b110 | poz_par_i == 3'b100)
			begin
					pontok_count <= pontok_count + 1'b1;
					if(pontok_count == 5'b11111)
						State <= vege;
					State <= mov_pac_write_1;
			end		
	end

	mov_pac_last_direction:				////00110
	begin
		rd_en <= 1;				////rd_en <= 1;
			case(last_direction)
				2'b00 : next_poz <= pac_poz - 10'b0000101000;		//up		+2h'28
				2'b01 : next_poz <= pac_poz - 10'b0000000001;		//left 10'b0000011110;	+2h'1E
				2'b10 : next_poz <= pac_poz + 10'b0000101000;		//down	-2h'28
				2'b11 : next_poz <= pac_poz + 10'b0000000001;		//right 10'b0000011110;	-2h'1E
				default : next_poz <= pac_poz - 10'b0000000001;		//10'b0000011110;
			endcase
			state_led <= 8'b00000110;
		State <= mov_pac_memrd_addr2;			
	end
	
	mov_pac_memrd_addr2:							////01100
	begin
	rd_en <= 0;
	state_led <= 8'b00000111;
	State <= mov_pac_last_check;
	end
	
	mov_pac_last_check:						////00111
	begin
	state_led <= 8'b00001000;
		if(poz_par_i == 3'b000 | poz_par_i == 3'b001)		//last_poz_par_i
		begin
			next_poz <= pac_poz;
			//next_poz_par <= 3'b010;		//pacman
			//last_poz <= pac_poz;
			//last_poz_par <= last_poz_par_i;
			wr_b <= 1'b0;
												//last_direction <= next_direction;
			State <= ack1;
		end
		else									// if(last_poz_par_i == 3'b101 | last_poz_par_i == 3'b110 | last_poz_par_i == 3'b100)
			State <= mov_pac_last_write_1;
	end
	
	mov_pac_write_1:						////01101
	begin
	state_led <= 8'b00001001;
		//last_poz <= next_poz;
		//last_poz_par <= 3'b100;		//út
		poz_par <= 3'b010;		//pacman
		last_direction <= next_direction;
		wr_b <= 1'b1;
							//State <= mov_ghost1;
		State <= mov_pac_write_1_d;
	end
	
	mov_pac_write_1_d:					///01110
	State <=mov_pac_write_2;
	
	mov_pac_write_2:					////01111
	begin
	poz_par <= 3'b100;		//út
	next_poz <= pac_poz;
	pac_poz <= next_poz;
	State <= mov_pac_write_2_d;
	end
	
	mov_pac_write_2_d:				////10000
	State <= ack1;

	mov_pac_last_write_1:			///10001
	begin
		//next_direction <= last_direction;			//////
		state_led <= 8'b00001010;
		//last_poz <= next_poz;
		//last_poz_par <= 3'b100;		//út
		poz_par <= 3'b010;		//pacman
		next_direction <= last_direction; 	//!!
		wr_b <= 1'b1;
		//State <= mov_ghost1;
		State <= mov_pac_last_write_1_d;
	end
	
	mov_pac_last_write_1_d:				////10010
	State <= mov_pac_last_write_2;
	
	mov_pac_last_write_2:				////10011
	begin
	poz_par <= 3'b100;
	next_poz <= pac_poz;
	pac_poz <= next_poz;
	State <= mov_pac_last_write_2_d;			
	end
	
	mov_pac_last_write_2_d:				///10100
	State <= ack1;

	
	ack1:
	begin
	ack <= 1;
	State <= ack2;
	end
	
	ack2:
	begin
	ack <= 0;
	State <= mov_ghost1;
	end
		

	mov_ghost1:						///01001
	begin
		state_led <= 8'b00001011;
		wr_b <= 0;
		State <= idle;
	end
		
	vege:								////01010
		state_led <= 8'b00001100;

	default : State <= idle;
	
	endcase
	
end

	assign poz_par_o = poz_par;
	assign wr_b_o = wr_b;
	assign next_poz_o = next_poz;
	assign pontok_count_o = pontok_count;
	assign state_led_o = state_led;
	assign pac_poz_o = pac_poz;
	assign rd_en_o = rd_en;
	assign ack_o = ack;

endmodule
