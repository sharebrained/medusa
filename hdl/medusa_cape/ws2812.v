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

parameter		SYMBOL_0_HIGH = CYCLES_0_HIGH,				
				SYMBOL_0_DURATION = CYCLES_BIT;			

parameter		SYMBOL_1_HIGH = CYCLES_1_HIGH,			
				SYMBOL_1_DURATION = CYCLES_BIT;

parameter		SYMBOL_RESET_HIGH = 0,
				SYMBOL_RESET_DURATION = CYCLES_RESET;

reg		[8:0]	led_pixel_count_q;

assign			address_o = (REVERSE != 0) ? (LED_COUNT - 1 - led_pixel_count_q) : led_pixel_count_q;

wire	[23:0]	led_data = { g_i[7:0], r_i[7:0], b_i[7:0] };

reg		[1:0]	led_symbol_q;
parameter		LED_SYMBOL_0 = 2'd0,
				LED_SYMBOL_1 = 2'd1,
				LED_SYMBOL_RESET = 2'd2;

reg		[11:0]	led_symbol_duration;
reg		[11:0]	led_symbol_phase_q;
wire	[11:0]	led_symbol_phase_next;
wire	[11:0]	led_symbol_phase_inc = (led_symbol_phase_q + 12'b1);
assign			led_symbol_phase_next = (led_symbol_phase_inc < led_symbol_duration) ? led_symbol_phase_inc : 12'b0;

reg				led_out;

always @(led_symbol_q or led_symbol_phase_q) begin
	case(led_symbol_q)
	LED_SYMBOL_0: begin
		led_symbol_duration = SYMBOL_0_DURATION;
		led_out = (led_symbol_phase_q < SYMBOL_0_HIGH);
	end

	LED_SYMBOL_1: begin
		led_symbol_duration = SYMBOL_1_DURATION;
		led_out = (led_symbol_phase_q < SYMBOL_1_HIGH);
	end

	LED_SYMBOL_RESET: begin
		led_symbol_duration = SYMBOL_RESET_DURATION;
		led_out = (led_symbol_phase_q < SYMBOL_RESET_HIGH);
	end

	endcase
end

reg				led_out_q;
assign			data_o = led_out_q;

always @(posedge clk_i) begin
	if (rst_i) begin
		led_symbol_phase_q <= 0;
		led_out_q <= 0;
	end
	else begin
		led_symbol_phase_q <= led_symbol_phase_next;
		led_out_q <= led_out;
	end
end

wire			led_symbol_next = (led_symbol_phase_next == 0);

reg		[4:0]	led_symbol_count_q;
wire	[4:0]	led_symbol_count_next = (led_symbol_count_q == 0) ? 5'd23 : (led_symbol_count_q - 5'b1);
wire			led_symbol_last = (led_symbol_count_q == 0);

always @(posedge clk_i) begin
	if (rst_i) begin
		led_symbol_count_q <= 23;
	end
	else begin
		if (led_symbol_next) begin
			led_symbol_count_q <= led_symbol_count_next;
		end
	end
end

wire			led_pixel_next = (led_symbol_last) && (led_symbol_next == 1);
wire			led_pixel_last = (led_pixel_count_q == 1);
wire	[8:0]	led_pixel_count_init = LED_COUNT - 1;
wire	[8:0]	led_pixel_count_advance = led_pixel_count_q - 9'b1;
wire	[8:0]	led_pixel_count_next = led_pixel_last ? led_pixel_count_init : led_pixel_count_advance;

always @(posedge clk_i) begin
	if (rst_i) begin
		led_pixel_count_q <= led_pixel_count_init;
	end
	else begin
		if (led_pixel_next) begin
			led_pixel_count_q <= led_pixel_count_next;
		end
	end
end

wire			led_frame_end = (led_pixel_next) && (led_pixel_last);

always @(posedge clk_i) begin
	if (rst_i) begin
		led_symbol_q <= LED_SYMBOL_RESET;
	end
	else begin
		if (led_symbol_next) begin
			if (led_frame_end) begin
				led_symbol_q <= LED_SYMBOL_RESET;
			end
			else begin
				led_symbol_q <= led_data[led_symbol_count_q] ? LED_SYMBOL_1 : LED_SYMBOL_0;
			end
		end
	end
end

endmodule
