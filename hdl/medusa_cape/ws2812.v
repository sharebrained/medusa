// Driver for WS2812 LED strips.
// Serializes data to an LED strip.

// Copyright (c) 2013 Jared Boone, ShareBrained Technology, Inc.
//
// This file is part of the Medusa project.
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2, or (at your option)
// any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; see the file COPYING.  If not, write to
// the Free Software Foundation, Inc., 51 Franklin Street,
// Boston, MA 02110-1301, USA.
//

module ws2812
#(parameter LED_COUNT, parameter REVERSE)
(
	input			rst_i,
	input			clk_i,

	output	[8:0]	address_o,
	input	[7:0]	r_i,
	input	[7:0]	g_i,
	input	[7:0]	b_i,

	output			data_o
);

/* WS2812 data sheet:
 * T0H + T0L = 350 ns + 800 ns = 1.15 us
 * T1H + T1L = 700 ns + 600 ns = 1.3 us
 * Treset = >50 us
 */

parameter		CYCLES_0_HIGH = 21;	//  0.42 us @ 50MHz
parameter		CYCLES_1_HIGH = 42;	//  0.84 us @ 50MHz
parameter		CYCLES_BIT = 63;		//  1.26 us @ 50MHz
parameter		CYCLES_RESET = 2600;	// 52.00 us @ 50MHz

parameter		STATE_PIXEL = 0,
				STATE_SYNC = 1;
reg		[1:0]	state;

parameter		SYMBOL_0 = 0,
				SYMBOL_1 = 1,
				SYMBOL_RESET = 2;
wire	[1:0]	symbol;

reg		[11:0]	symbol_phase;
reg		[11:0]	symbol_duration;
reg		[11:0]	symbol_high_time;

always @(symbol) begin
	case(symbol)
	SYMBOL_0:		symbol_high_time = CYCLES_0_HIGH;
	SYMBOL_1:		symbol_high_time = CYCLES_1_HIGH;
	default:		symbol_high_time = 0;
	endcase
end

always @(symbol) begin
	case(symbol)
	SYMBOL_0:		symbol_duration = CYCLES_BIT;
	SYMBOL_1:		symbol_duration = CYCLES_BIT;
	default:		symbol_duration = CYCLES_RESET;
	endcase
end

reg				symbol_out;
assign	 		data_o = symbol_out;

wire			symbol_end = (symbol_phase == (symbol_duration - 1));

always @(posedge clk_i) begin
	if (rst_i) begin
		symbol_phase <= 0;
		symbol_out <= 0;
	end
	else begin
		symbol_out <= (symbol_phase < symbol_high_time);

		if (symbol_end)
			symbol_phase <= 0;
		else
			symbol_phase <= symbol_phase + 1;
	end
end

reg		[4:0]	symbol_count;
wire			pixel_end = (symbol_count == 23) && symbol_end;

wire	[23:0]	led_data = { g_i[7:0], r_i[7:0], b_i[7:0] };

always @(posedge clk_i) begin
	if (rst_i)
		symbol_count <= 0;
	else begin
		if (symbol_end)
			if (pixel_end)
				symbol_count <= 0;
			else
				if (state == STATE_PIXEL)
					symbol_count <= symbol_count + 1;
	end
end

reg		[8:0]	pixel_count;
wire			frame_end = (pixel_count == (LED_COUNT - 1)) && pixel_end;

assign			symbol = (state == STATE_PIXEL) ? led_data[23 - symbol_count] : SYMBOL_RESET;

always @(posedge clk_i) begin
	if (rst_i) begin
		state <= STATE_SYNC;
		pixel_count <= 0;
	end
	else begin
		case(state)
		STATE_PIXEL: begin
			if (pixel_end) begin
				if (frame_end) begin
					state <= STATE_SYNC;
					pixel_count <= 0;
				end
				else begin
					state <= STATE_PIXEL;
					pixel_count <= pixel_count + 1;
				end
			end
			else begin
				state <= STATE_PIXEL;
				pixel_count <= pixel_count;
			end
		end

		default: begin
			if (symbol_end) begin
				state <= STATE_PIXEL;
				pixel_count <= 0;
			end
			else begin
				state <= STATE_SYNC;
				pixel_count <= 0;
			end
		end
		endcase
	end
end

assign			address_o = REVERSE ? pixel_count : (LED_COUNT - 1 - pixel_count);

endmodule
