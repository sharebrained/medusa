// Pixel RAM. LCD pixel -> RAM -> LED pixel.

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

module pixel_ram
#(parameter DATA_WIDTH=24, parameter ADDR_WIDTH=9)
(
	input [(DATA_WIDTH-1):0] data_a,
	input [(ADDR_WIDTH-1):0] addr_a, addr_b,
	input we_a, clk_a, clk_b,
	output reg [(DATA_WIDTH-1):0] q_b
);

	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0];

	always @ (posedge clk_a)
	begin
		if (we_a) 
			ram[addr_a] <= data_a;
	end

	always @ (posedge clk_b)
	begin
		q_b <= ram[addr_b];
	end

endmodule
