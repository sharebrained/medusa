Medusa
======

Gonzo LED strip lighting controller, driven from video output that's easy to program.

The hardware is in three parts:

* Medusa Cape: BeagleBone Black cape that snoops the LCD video output of the BeagleBone and picks off RGB pixel values. Those values are mapped to LED pixels on one of 32 WS2811/WS2812 LED strips of up to 512 LEDs each.
* Medusa TX32: A 32-channel RS-422 transmitter board that sends 4 pairs of RS-422 signalling out of each of eight RJ-45 connectors. Common CAT5/6 Ethernet cabling (TIA-568B) can be used to connect up to four strips on each cable.
* Medusa RX2: A 2-channel RS-422 receiver board that picks off two channels of RS-422 on a cable, and passes the two remaining signals out another cable (so two 2-channel receivers can be chained to use all four channels on a single Ethernet cable).

Dependencies
============

For developing this project, the following tools were used:

* Schematic capture and PCB layout: KiCAD -testing branch, builds from late September or early October 2013
* FPGA development and bitstream generation: Altera Quartus II 13.0 SP 1 FPGA development environment, for Windows or Linux
* BeagleBone Linux distribution: Angstrom, September 4, 2013
* Python 2.7

License
=======

The associated software is provided under a GPLv2 license:

Copyright (C) 2013 Jared Boone, ShareBrained Technology, Inc.

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
02110-1301, USA.

Contact
=======

Jared Boone <jared@sharebrained.com>

ShareBrained Technology, Inc.

<http://www.sharebrained.com/>

The latest version of this repository can be found at
https://github.com/sharebrained/medusa
