// Logic to map a wall edge lighting region's LED pixels to LCD pixels.

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

module map_wall_edge (
	input			pixel_clk_i,
	input	[11:0]	pixel_x_i,
	input	[11:0]	pixel_y_i,
	input			pixel_valid_i,

	output	[9:0]	led_strip_address_o,
	output			led_strip_address_valid_o
);

//parameter		VSYNC_VBI_LINE_COUNT = 29;	// good for 24-bit color mode?
parameter		VSYNC_VBI_LINE_COUNT = 16;	// good for 16-bit color mode?

parameter	X = 0;
parameter	Y_START = 2 + VSYNC_VBI_LINE_COUNT;
parameter	Y_END = Y_START + 237;

assign	led_strip_address_valid_o = pixel_valid_i && (pixel_x_i == X) && (pixel_y_i >= Y_START) && (pixel_y_i < Y_END);
assign	led_strip_address_o = pixel_y_i - Y_START;

endmodule
