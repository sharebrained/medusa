// Top block for Medusa BeagleBone Black cape, connects LCD interface to
// 32 WS2812 LED strips, according to the arrangement of strips at Ada's
// Technical Bookstore in Seattle, WA, USA.

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

module top (
	input			SYSCLK_i,
	
	input	[23:0]	LCD_DATA_i,
	input			LCD_PCLK_i,
	input			LCD_VSYNC_i,
	input			LCD_HSYNC_i,
	input			LCD_DE_i,

	output	[31:0]	STRIP_o,
	output	[7:0]	PORT_EN_o,
	output			PWR_EN,
	input			PWRGD,

	output			SYSCLK_ACTIVE_o,
	output			LCD_PCLK_ACTIVE_o
);

wire rst;

por por_instance (
	.clk(SYSCLK_i),
	.rst(rst)
);

assign PWR_EN = !rst;
assign PORT_EN_o = 8'b00000000;

reg		[31:0]	sysclk_counter;
always @(posedge SYSCLK_i) begin
	sysclk_counter <= sysclk_counter + 1;
end
assign			SYSCLK_ACTIVE_o = sysclk_counter[24];

reg		[31:0]	lcd_pclk_counter;
always @(posedge LCD_PCLK_i) begin
	lcd_pclk_counter <= lcd_pclk_counter + 1;
end
assign			LCD_PCLK_ACTIVE_o = lcd_pclk_counter[24];

wire			led_clk = SYSCLK_i;

wire			lcd_clk;
wire	[11:0]	lcd_x;
wire	[11:0]	lcd_y;
wire	[23:0]	lcd_data;
wire			lcd_data_valid;

wire	[23:0]	lcd_data24;
//assign			lcd_data24 = LCD_PCLK_ACTIVE_o ? 24'hffffff : 24'h000000;
assign			lcd_data24 = {
	LCD_DATA_i[15:11], LCD_DATA_i[15:13],
	LCD_DATA_i[10: 5], LCD_DATA_i[10: 9],
	LCD_DATA_i[ 4: 0], LCD_DATA_i[ 4: 2],
};
/*
assign			lcd_data24 = {
	LCD_DATA_i[23:16],
	LCD_DATA_i[15: 8],
	LCD_DATA_i[ 7: 0]
};
*/
lcd_sync lcd_sync (
	.rst(rst),
	.lcd_data_i(lcd_data24),
	.lcd_pclk_i(LCD_PCLK_i),
	.lcd_vsync_i(LCD_VSYNC_i),
	.lcd_hsync_i(LCD_HSYNC_i),
	.lcd_de_i(LCD_DE_i),
	.lcd_clk_o(lcd_clk),
	.lcd_x_o(lcd_x),
	.lcd_y_o(lcd_y),
	.lcd_data_o(lcd_data),
	.lcd_data_valid_o(lcd_data_valid)
);

wire	[23:0]	lcd_data_gamma;

gamma gamma_r (
	.v_i(lcd_data[23:16]),
	.v_o(lcd_data_gamma[23:16])
);

gamma gamma_g (
	.v_i(lcd_data[15: 8]),
	.v_o(lcd_data_gamma[15: 8])
);

gamma gamma_b (
	.v_i(lcd_data[ 7: 0]),
	.v_o(lcd_data_gamma[ 7: 0])
);

wire	[7:0]	lcd_data_r = lcd_data_gamma[23:16];
wire	[7:0]	lcd_data_g = lcd_data_gamma[15: 8];
wire	[7:0]	lcd_data_b = lcd_data_gamma[ 7: 0];

/*********************************************************************/
/* Edge 0 */

wire	[9:0]	edge_0a_address;
wire			edge_0a_address_valid;
map_wall_edge #(.X(0)) edge_0a (
	.pixel_clk_i(lcd_clk),
	.pixel_x_i(lcd_x),
	.pixel_y_i(lcd_y),
	.pixel_valid_i(lcd_data_valid),
	.led_strip_address_o(edge_0a_address),
	.led_strip_address_valid_o(edge_0a_address_valid)
);

strip_ws2812 #(.LED_COUNT(237)) edge_0a_strip (
	.rst_i(rst),
	.pixel_clk_i(lcd_clk),
	.pixel_r_i(lcd_data_r),
	.pixel_g_i(lcd_data_g),
	.pixel_b_i(lcd_data_b),
	.led_address_i(edge_0a_address),
	.led_address_valid_i(edge_0a_address_valid),
	.led_clk_i(led_clk),
	.led_data_o(STRIP_o[0])
);

wire	[9:0]	edge_0b_address;
wire			edge_0b_address_valid;
map_wall_edge #(.X(1)) edge_0b (
	.pixel_clk_i(lcd_clk),
	.pixel_x_i(lcd_x),
	.pixel_y_i(lcd_y),
	.pixel_valid_i(lcd_data_valid),
	.led_strip_address_o(edge_0b_address),
	.led_strip_address_valid_o(edge_0b_address_valid)
);

strip_ws2812 #(.LED_COUNT(237)) edge_0b_strip (
	.rst_i(rst),
	.pixel_clk_i(lcd_clk),
// Removed due to faulty channel.
	.pixel_r_i(lcd_data_r),
	.pixel_g_i(lcd_data_g),
	.pixel_b_i(lcd_data_b),
// Added due to faulty channel.
	//.pixel_r_i(8'h00),
	//.pixel_g_i(8'h00),
	//.pixel_b_i(8'h00),
	.led_address_i(edge_0b_address),
	.led_address_valid_i(edge_0b_address_valid),
	.led_clk_i(led_clk),
	.led_data_o(STRIP_o[1])
);

/*********************************************************************/
/* Door 0 */

wire	[9:0]	door_0a_address;
wire			door_0a_address_valid;
map_door #(.X_V1(34), .X_V2(101), .Y_V(112), .X_H(36), .Y_H(110)) door_0a (
	.pixel_clk_i(lcd_clk),
	.pixel_x_i(lcd_x),
	.pixel_y_i(lcd_y),
	.pixel_valid_i(lcd_data_valid),
	.led_strip_address_o(door_0a_address),
	.led_strip_address_valid_o(door_0a_address_valid)
);

strip_ws2812 #(.LED_COUNT(320)) door_0a_strip (
	.rst_i(rst),
	.pixel_clk_i(lcd_clk),
	.pixel_r_i(lcd_data_r),
	.pixel_g_i(lcd_data_g),
	.pixel_b_i(lcd_data_b),
	.led_address_i(door_0a_address),
	.led_address_valid_i(door_0a_address_valid),
	.led_clk_i(led_clk),
	.led_data_o(STRIP_o[4])
);

wire	[9:0]	door_0b_address;
wire			door_0b_address_valid;
map_door #(.X_V1(35), .X_V2(102), .Y_V(112), .X_H(36), .Y_H(111)) door_0b (
	.pixel_clk_i(lcd_clk),
	.pixel_x_i(lcd_x),
	.pixel_y_i(lcd_y),
	.pixel_valid_i(lcd_data_valid),
	.led_strip_address_o(door_0b_address),
	.led_strip_address_valid_o(door_0b_address_valid)
);

strip_ws2812 #(.LED_COUNT(320)) door_0b_strip (
	.rst_i(rst),
	.pixel_clk_i(lcd_clk),
	.pixel_r_i(lcd_data_r),
	.pixel_g_i(lcd_data_g),
	.pixel_b_i(lcd_data_b),
	.led_address_i(door_0b_address),
	.led_address_valid_i(door_0b_address_valid),
	.led_clk_i(led_clk),
	.led_data_o(STRIP_o[5])
);

/*********************************************************************/
/* Edge 1 */

wire	[9:0]	edge_1a_address;
wire			edge_1a_address_valid;
map_wall_edge #(.X(134)) edge_1a (
	.pixel_clk_i(lcd_clk),
	.pixel_x_i(lcd_x),
	.pixel_y_i(lcd_y),
	.pixel_valid_i(lcd_data_valid),
	.led_strip_address_o(edge_1a_address),
	.led_strip_address_valid_o(edge_1a_address_valid)
);

strip_ws2812 #(.LED_COUNT(237)) edge_1a_strip (
	.rst_i(rst),
	.pixel_clk_i(lcd_clk),
	.pixel_r_i(lcd_data_r),
	.pixel_g_i(lcd_data_g),
	.pixel_b_i(lcd_data_b),
	.led_address_i(edge_1a_address),
	.led_address_valid_i(edge_1a_address_valid),
	.led_clk_i(led_clk),
	.led_data_o(STRIP_o[6])
);

wire	[9:0]	edge_1b_address;
wire			edge_1b_address_valid;
map_wall_edge #(.X(135)) edge_1b (
	.pixel_clk_i(lcd_clk),
	.pixel_x_i(lcd_x),
	.pixel_y_i(lcd_y),
	.pixel_valid_i(lcd_data_valid),
	.led_strip_address_o(edge_1b_address),
	.led_strip_address_valid_o(edge_1b_address_valid)
);

strip_ws2812 #(.LED_COUNT(237)) edge_1b_strip (
	.rst_i(rst),
	.pixel_clk_i(lcd_clk),
	.pixel_r_i(lcd_data_r),
	.pixel_g_i(lcd_data_g),
	.pixel_b_i(lcd_data_b),
	.led_address_i(edge_1b_address),
	.led_address_valid_i(edge_1b_address_valid),
	.led_clk_i(led_clk),
	.led_data_o(STRIP_o[7])
);

/*********************************************************************/
/* Edge 2 */

wire	[9:0]	edge_2a_address;
wire			edge_2a_address_valid;
map_wall_edge #(.X(229)) edge_2a (
	.pixel_clk_i(lcd_clk),
	.pixel_x_i(lcd_x),
	.pixel_y_i(lcd_y),
	.pixel_valid_i(lcd_data_valid),
	.led_strip_address_o(edge_2a_address),
	.led_strip_address_valid_o(edge_2a_address_valid)
);

strip_ws2812 #(.LED_COUNT(237)) edge_2a_strip (
	.rst_i(rst),
	.pixel_clk_i(lcd_clk),
	.pixel_r_i(lcd_data_r),
	.pixel_g_i(lcd_data_g),
	.pixel_b_i(lcd_data_b),
	.led_address_i(edge_2a_address),
	.led_address_valid_i(edge_2a_address_valid),
	.led_clk_i(led_clk),
	.led_data_o(STRIP_o[8])
);

wire	[9:0]	edge_2b_address;
wire			edge_2b_address_valid;
map_wall_edge #(.X(230)) edge_2b (
	.pixel_clk_i(lcd_clk),
	.pixel_x_i(lcd_x),
	.pixel_y_i(lcd_y),
	.pixel_valid_i(lcd_data_valid),
	.led_strip_address_o(edge_2b_address),
	.led_strip_address_valid_o(edge_2b_address_valid)
);

strip_ws2812 #(.LED_COUNT(237)) edge_2b_strip (
	.rst_i(rst),
	.pixel_clk_i(lcd_clk),
	.pixel_r_i(lcd_data_r),
	.pixel_g_i(lcd_data_g),
	.pixel_b_i(lcd_data_b),
	.led_address_i(edge_2b_address),
	.led_address_valid_i(edge_2b_address_valid),
	.led_clk_i(led_clk),
	.led_data_o(STRIP_o[9])
);

/*********************************************************************/
/* Door 1 */

wire	[9:0]	door_1a_address;
wire			door_1a_address_valid;
map_door #(.X_V1(263), .X_V2(330), .Y_V(112), .X_H(265), .Y_H(110)) door_1a (
	.pixel_clk_i(lcd_clk),
	.pixel_x_i(lcd_x),
	.pixel_y_i(lcd_y),
	.pixel_valid_i(lcd_data_valid),
	.led_strip_address_o(door_1a_address),
	.led_strip_address_valid_o(door_1a_address_valid)
);

strip_ws2812 #(.LED_COUNT(320), .REVERSE(1)) door_1a_strip (
	.rst_i(rst),
	.pixel_clk_i(lcd_clk),
	.pixel_r_i(lcd_data_r),
	.pixel_g_i(lcd_data_g),
	.pixel_b_i(lcd_data_b),
	.led_address_i(door_1a_address),
	.led_address_valid_i(door_1a_address_valid),
	.led_clk_i(led_clk),
	.led_data_o(STRIP_o[10])
);

wire	[9:0]	door_1b_address;
wire			door_1b_address_valid;
map_door #(.X_V1(264), .X_V2(331), .Y_V(112), .X_H(265), .Y_H(111)) door_1b (
	.pixel_clk_i(lcd_clk),
	.pixel_x_i(lcd_x),
	.pixel_y_i(lcd_y),
	.pixel_valid_i(lcd_data_valid),
	.led_strip_address_o(door_1b_address),
	.led_strip_address_valid_o(door_1b_address_valid)
);

strip_ws2812 #(.LED_COUNT(320), .REVERSE(1)) door_1b_strip (
	.rst_i(rst),
	.pixel_clk_i(lcd_clk),
	.pixel_r_i(lcd_data_r),
	.pixel_g_i(lcd_data_g),
	.pixel_b_i(lcd_data_b),
	.led_address_i(door_1b_address),
	.led_address_valid_i(door_1b_address_valid),
	.led_clk_i(led_clk),
	.led_data_o(STRIP_o[11])
);

/*********************************************************************/
/* Door 2 */

wire	[9:0]	door_2a_address;
wire			door_2a_address_valid;
map_door #(.X_V1(361), .X_V2(428), .Y_V(112), .X_H(363), .Y_H(110)) door_2a (
	.pixel_clk_i(lcd_clk),
	.pixel_x_i(lcd_x),
	.pixel_y_i(lcd_y),
	.pixel_valid_i(lcd_data_valid),
	.led_strip_address_o(door_2a_address),
	.led_strip_address_valid_o(door_2a_address_valid)
);

strip_ws2812 #(.LED_COUNT(320), .REVERSE(1)) door_2a_strip (
	.rst_i(rst),
	.pixel_clk_i(lcd_clk),
	.pixel_r_i(lcd_data_r),
	.pixel_g_i(lcd_data_g),
	.pixel_b_i(lcd_data_b),
	.led_address_i(door_2a_address),
	.led_address_valid_i(door_2a_address_valid),
	.led_clk_i(led_clk),
	.led_data_o(STRIP_o[12])
);

wire	[9:0]	door_2b_address;
wire			door_2b_address_valid;
map_door #(.X_V1(362), .X_V2(429), .Y_V(112), .X_H(363), .Y_H(111)) door_2b (
	.pixel_clk_i(lcd_clk),
	.pixel_x_i(lcd_x),
	.pixel_y_i(lcd_y),
	.pixel_valid_i(lcd_data_valid),
	.led_strip_address_o(door_2b_address),
	.led_strip_address_valid_o(door_2b_address_valid)
);

strip_ws2812 #(.LED_COUNT(320), .REVERSE(1)) door_2b_strip (
	.rst_i(rst),
	.pixel_clk_i(lcd_clk),
	.pixel_r_i(lcd_data_r),
	.pixel_g_i(lcd_data_g),
	.pixel_b_i(lcd_data_b),
	.led_address_i(door_2b_address),
	.led_address_valid_i(door_2b_address_valid),
	.led_clk_i(led_clk),
	.led_data_o(STRIP_o[13])
);

/*********************************************************************/
/* Edge 3 */

wire	[9:0]	edge_3a_address;
wire			edge_3a_address_valid;
map_wall_edge #(.X(462)) edge_3a (
	.pixel_clk_i(lcd_clk),
	.pixel_x_i(lcd_x),
	.pixel_y_i(lcd_y),
	.pixel_valid_i(lcd_data_valid),
	.led_strip_address_o(edge_3a_address),
	.led_strip_address_valid_o(edge_3a_address_valid)
);

strip_ws2812 #(.LED_COUNT(237)) edge_3a_strip (
	.rst_i(rst),
	.pixel_clk_i(lcd_clk),
	.pixel_r_i(lcd_data_r),
	.pixel_g_i(lcd_data_g),
	.pixel_b_i(lcd_data_b),
	.led_address_i(edge_3a_address),
	.led_address_valid_i(edge_3a_address_valid),
	.led_clk_i(led_clk),
	.led_data_o(STRIP_o[17])
);

wire	[9:0]	edge_3b_address;
wire			edge_3b_address_valid;
map_wall_edge #(.X(463)) edge_3b (
	.pixel_clk_i(lcd_clk),
	.pixel_x_i(lcd_x),
	.pixel_y_i(lcd_y),
	.pixel_valid_i(lcd_data_valid),
	.led_strip_address_o(edge_3b_address),
	.led_strip_address_valid_o(edge_3b_address_valid)
);

strip_ws2812 #(.LED_COUNT(237)) edge_3b_strip (
	.rst_i(rst),
	.pixel_clk_i(lcd_clk),
	.pixel_r_i(lcd_data_r),
	.pixel_g_i(lcd_data_g),
	.pixel_b_i(lcd_data_b),
	.led_address_i(edge_3b_address),
	.led_address_valid_i(edge_3b_address_valid),
	.led_clk_i(led_clk),
	.led_data_o(STRIP_o[16])
);

endmodule
