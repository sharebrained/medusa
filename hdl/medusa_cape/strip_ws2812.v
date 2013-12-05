// Wrapper to store WS2812 pixels in a RAM block for independent
// read-out.

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

module strip_ws2812 (
	input			rst_i,

	input			pixel_clk_i,
	input	[7:0]	pixel_r_i,
	input	[7:0]	pixel_g_i,
	input	[7:0]	pixel_b_i,

	input	[8:0]	led_address_i,
	input			led_address_valid_i,

	input			led_clk_i,
	output			led_data_o
);

parameter LED_COUNT;
parameter REVERSE = 0;

wire			pixel_ram_wclk = pixel_clk_i;
wire	[8:0]	pixel_ram_waddr = led_address_i;
wire	[23:0]	pixel_ram_wdata = { pixel_r_i, pixel_g_i, pixel_b_i };
wire			pixel_ram_we = led_address_valid_i;

wire			pixel_ram_rclk = led_clk_i;
wire	[8:0]	pixel_ram_raddr;
wire	[23:0]	pixel_ram_rdata;

pixel_ram pixel_ram (
	.clk_a(pixel_ram_wclk),
	.addr_a(pixel_ram_waddr),
	.data_a(pixel_ram_wdata),
	.we_a(pixel_ram_we),
	
	.clk_b(pixel_ram_rclk),
	.addr_b(pixel_ram_raddr),
	.q_b(pixel_ram_rdata)
);

ws2812
#(.LED_COUNT(LED_COUNT), .REVERSE(REVERSE))
ws2812 (
	.rst_i(rst_i),
	.address_o(pixel_ram_raddr),
	.r_i(pixel_ram_rdata[23:16]),
	.g_i(pixel_ram_rdata[15: 8]),
	.b_i(pixel_ram_rdata[ 7: 0]),
	.clk_i(led_clk_i),
	.data_o(led_data_o)
);

endmodule
