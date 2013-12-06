// Testbench for WS2812 driver.

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

`timescale 1ns/1ps

module ws2812_tb;
	reg				rst;
	
	reg				clk;
	wire		[8:0] 	address;
	reg		[7:0]	r;
	reg 	[7:0]	g;
	reg 	[7:0]	b;
	
	wire			strip_o;

	ws2812 #(.LED_COUNT(8), .REVERSE(0)) uut (
		.rst_i(rst),
		.clk_i(clk),
		.address_o(address),
		.r_i(r),
		.g_i(g),
		.b_i(b),
		.data_o(strip_o)
	);

initial
begin
	rst = 1;
	clk = 0;
	r = 0;
	g = 0;
	b = 0;

	#100 rst = 0;
end

always
	#10 clk = !clk;

always @(posedge clk) begin
	if (rst == 0) begin
		r <= address;
		g <= address + 100;
		b <= address + 200;
	end
end

endmodule
