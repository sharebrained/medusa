# Timing constraints.

# Copyright (c) 2013 Jared Boone, ShareBrained Technology, Inc.
#
# This file is part of the Medusa project.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; see the file COPYING.  If not, write to
# the Free Software Foundation, Inc., 51 Franklin Street,
# Boston, MA 02110-1301, USA.
#

# Clock constraints

create_clock -name "LCD_PCLK" -period 20.000ns [get_ports {LCD_PCLK_i}]
create_clock -name "SYSCLK" -period 20.000ns [get_ports {SYSCLK_i}]

# Automatically constrain PLL and other generated clocks
derive_pll_clocks -create_base_clocks

# Automatically calculate clock uncertainty to jitter and other effects.
derive_clock_uncertainty

# tsu/th constraints

set_input_delay -clock "LCD_PCLK" -max 1.9ns [get_ports {LCD_DATA_i[*]}] 
set_input_delay -clock "LCD_PCLK" -min -1.7ns [get_ports {LCD_DATA_i[*]}] 
set_input_delay -clock "LCD_PCLK" -max 1.9ns [get_ports {LCD_DE_i}] 
set_input_delay -clock "LCD_PCLK" -min -1.7ns [get_ports {LCD_DE_i}] 

# tco constraints

# tpd constraints
