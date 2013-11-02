// LCD video synchronizer, generates X/Y coordinates, validity of
// current pixel RGB value.

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

module lcd_sync (
	input			rst,

	input	[23:0]	lcd_data_i,
	input			lcd_pclk_i,
	input			lcd_vsync_i,
	input			lcd_hsync_i,
	input			lcd_de_i,

	output			lcd_clk_o,
	output	[11:0]	lcd_x_o,
	output	[11:0]	lcd_y_o,
	output	[23:0]	lcd_data_o,
	output			lcd_data_valid_o
);

reg		[11:0]	lcd_x_q;
reg		[11:0]	lcd_y_q;
reg		[23:0]	lcd_data_q;
reg				lcd_hsync_q;
reg				lcd_vsync_q;
reg				lcd_de_q;

assign			lcd_clk_o = lcd_pclk_i;
assign			lcd_x_o = lcd_x_q;
assign			lcd_y_o = lcd_y_q;
assign			lcd_data_o = lcd_data_q;
assign			lcd_data_valid_o = lcd_de_q;

wire			lcd_hsync_end = (lcd_hsync_i == 0) && (lcd_hsync_q == 1);
wire			lcd_vsync_end = (lcd_vsync_i == 1) && (lcd_vsync_q == 0);

always @(posedge lcd_pclk_i) begin
	if (rst) begin
		lcd_x_q <= 0;
		lcd_y_q <= 0;
		lcd_data_q <= 0;
		lcd_hsync_q <= 0;
		lcd_vsync_q <= 0;
		lcd_de_q <= 0;
	end
	else begin
		lcd_hsync_q <= lcd_hsync_i;
		lcd_vsync_q <= lcd_vsync_i;
		lcd_de_q <= lcd_de_i;

		if (lcd_de_i) begin
			lcd_data_q <= lcd_data_i;
		end else begin
			lcd_data_q <= 0;
		end

		if (lcd_vsync_end) begin
			lcd_y_q <= 0;
		end else begin
			if (lcd_hsync_end) begin
				lcd_y_q <= lcd_y_q + 12'h1;
			end
		end

		if (lcd_hsync_end) begin
			lcd_x_q <= 0;
		end else begin
			if (lcd_de_q) begin
				lcd_x_q <= lcd_x_q + 12'h1;
			end
		end
	end
end

endmodule
