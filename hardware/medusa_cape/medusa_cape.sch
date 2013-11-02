EESchema Schematic File Version 2
LIBS:altera
LIBS:beaglebone_black
LIBS:ck
LIBS:conn_power
LIBS:conn_rj
LIBS:header
LIBS:on_cat24c256
LIBS:osc
LIBS:passive
LIBS:regulator
LIBS:supply
LIBS:switch
LIBS:ti
LIBS:tp
LIBS:medusa_cape-cache
EELAYER 24 0
EELAYER END
$Descr A3 16535 11693
encoding utf-8
Sheet 1 4
Title "Medusa LED Controller for BeagleBone"
Date ""
Rev "20131005"
Comp "ShareBrained Technology, Inc."
Comment1 "Copyright (C) 2013 Jared Boone"
Comment2 "License: GNU General Public License, version 2"
Comment3 ""
Comment4 ""
$EndDescr
Wire Bus Line
	8900 4600 10000 4600
Wire Bus Line
	8900 4800 10000 4800
$Sheet
S 5700 4400 1000 1200
U 52427A4F
F0 "Power" 50
F1 "medusa_power.sch" 50
F2 "1P2V" O R 6700 5200 60 
F3 "3P3V" O R 6700 4800 60 
F4 "2P5V" O R 6700 5000 60 
F5 "PWREN" I R 6700 5400 60 
F6 "V_RAW" I R 6700 4600 60 
$EndSheet
Wire Wire Line
	6700 4800 7900 4800
Wire Wire Line
	6700 5000 7900 5000
Wire Wire Line
	6700 5200 7900 5200
Wire Wire Line
	6700 5400 7900 5400
$Sheet
S 10000 4400 1050 1900
U 52491F15
F0 "IO" 50
F1 "medusa_io.sch" 50
F2 "V_RAW" I L 10000 5900 60 
F3 "PWREN" I L 10000 6100 60 
F4 "AF[19..0]" I L 10000 4600 60 
F5 "BF[19..0]" I L 10000 5000 60 
F6 "AS[3..0]" I L 10000 4800 60 
F7 "BS[3..0]" I L 10000 5200 60 
$EndSheet
$Sheet
S 7900 4400 1000 1200
U 5240BB71
F0 "FPGA" 50
F1 "medusa_fpga.sch" 50
F2 "1P2V" I L 7900 5200 60 
F3 "2P5V" I L 7900 5000 60 
F4 "3P3V" I L 7900 4800 60 
F5 "PWREN" O L 7900 5400 60 
F6 "V_RAW" O L 7900 4600 60 
F7 "AF[19..0]" O R 8900 4600 60 
F8 "BF[19..0]" O R 8900 5000 60 
F9 "AS[3..0]" O R 8900 4800 60 
F10 "BS[3..0]" O R 8900 5200 60 
$EndSheet
Wire Wire Line
	6700 4600 7900 4600
Wire Wire Line
	7200 4600 7200 5900
Wire Wire Line
	7200 5900 10000 5900
Connection ~ 7200 4600
Wire Wire Line
	7400 5400 7400 6100
Wire Wire Line
	7400 6100 10000 6100
Connection ~ 7400 5400
Wire Bus Line
	8900 5000 10000 5000
Wire Bus Line
	8900 5200 10000 5200
$EndSCHEMATC
