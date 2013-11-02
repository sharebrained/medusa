// Logic to map a doorway lighting region's LED pixels to LCD pixels.

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

module map_door (
	input			pixel_clk_i,
	input	[11:0]	pixel_x_i,
	input	[11:0]	pixel_y_i,
	input			pixel_valid_i,

	output	reg	[9:0]	led_strip_address_o,
	output			led_strip_address_valid_o
);

//parameter		VSYNC_VBI_LINE_COUNT = 29;	// good for 24-bit color mode?
parameter		VSYNC_VBI_LINE_COUNT = 16;	// good for 16-bit color mode?

parameter		X_V1;
parameter		X_V2;
parameter		Y_V;
parameter		X_H;
parameter		Y_H;

parameter		V_LEN = 127;
parameter		H_LEN = 65;

parameter		X1 = X_V1;
parameter		Y1_START = Y_V + VSYNC_VBI_LINE_COUNT;
parameter		Y1_END = Y1_START + V_LEN;

parameter		X2_START = X_H;
parameter		X2_END = X2_START + H_LEN;
parameter		Y2 = Y_H + VSYNC_VBI_LINE_COUNT;

parameter		X3 = X_V2;
parameter		Y3_START = Y_V + VSYNC_VBI_LINE_COUNT;
parameter		Y3_END = Y3_START + V_LEN;

wire			zone1_enable = (pixel_x_i == X1) && (pixel_y_i >= Y1_START) && (pixel_y_i < Y1_END);
wire	[9:0]	zone1_address = V_LEN - (pixel_y_i - Y1_START + (0));

wire			zone2_enable = (pixel_y_i == Y2) && (pixel_x_i >= X2_START) && (pixel_x_i < X2_END);
wire	[9:0]	zone2_address = pixel_x_i - X2_START + (V_LEN);

wire			zone3_enable = (pixel_x_i == X3) && (pixel_y_i >= Y3_START) && (pixel_y_i < Y3_END);
wire	[9:0]	zone3_address = pixel_y_i - Y3_START + (H_LEN + V_LEN);

wire			zone_enable = zone1_enable || zone2_enable || zone3_enable;

assign			led_strip_address_valid_o = pixel_valid_i && zone_enable;

always @(zone1_enable or zone2_enable or zone3_enable) begin
	if (zone3_enable) begin
		led_strip_address_o = zone3_address;
	end
	else if (zone2_enable) begin
		led_strip_address_o = zone2_address;
	end
	else begin
		led_strip_address_o = zone1_address;
	end
end

endmodule
