// Verilog asynchronous look-up table for LED brightness / gamma correction.

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

module gamma (
	input	[7:0]	v_i,
	output	reg	[7:0]	v_o
);

always @(v_i) begin
	case(v_i)
	0: v_o = 0;
	1: v_o = 1;
	2: v_o = 1;
	3: v_o = 1;
	4: v_o = 1;
	5: v_o = 1;
	6: v_o = 1;
	7: v_o = 1;
	8: v_o = 1;
	9: v_o = 1;
	10: v_o = 1;
	11: v_o = 1;
	12: v_o = 1;
	13: v_o = 1;
	14: v_o = 1;
	15: v_o = 1;
	16: v_o = 1;
	17: v_o = 1;
	18: v_o = 1;
	19: v_o = 1;
	20: v_o = 1;
	21: v_o = 1;
	22: v_o = 1;
	23: v_o = 1;
	24: v_o = 1;
	25: v_o = 1;
	26: v_o = 1;
	27: v_o = 1;
	28: v_o = 1;
	29: v_o = 1;
	30: v_o = 1;
	31: v_o = 1;
	32: v_o = 1;
	33: v_o = 2;
	34: v_o = 2;
	35: v_o = 2;
	36: v_o = 2;
	37: v_o = 2;
	38: v_o = 2;
	39: v_o = 2;
	40: v_o = 2;
	41: v_o = 3;
	42: v_o = 3;
	43: v_o = 3;
	44: v_o = 3;
	45: v_o = 3;
	46: v_o = 4;
	47: v_o = 4;
	48: v_o = 4;
	49: v_o = 4;
	50: v_o = 4;
	51: v_o = 5;
	52: v_o = 5;
	53: v_o = 5;
	54: v_o = 5;
	55: v_o = 6;
	56: v_o = 6;
	57: v_o = 6;
	58: v_o = 6;
	59: v_o = 7;
	60: v_o = 7;
	61: v_o = 7;
	62: v_o = 7;
	63: v_o = 8;
	64: v_o = 8;
	65: v_o = 8;
	66: v_o = 9;
	67: v_o = 9;
	68: v_o = 9;
	69: v_o = 10;
	70: v_o = 10;
	71: v_o = 10;
	72: v_o = 11;
	73: v_o = 11;
	74: v_o = 12;
	75: v_o = 12;
	76: v_o = 12;
	77: v_o = 13;
	78: v_o = 13;
	79: v_o = 14;
	80: v_o = 14;
	81: v_o = 15;
	82: v_o = 15;
	83: v_o = 15;
	84: v_o = 16;
	85: v_o = 16;
	86: v_o = 17;
	87: v_o = 17;
	88: v_o = 18;
	89: v_o = 18;
	90: v_o = 19;
	91: v_o = 19;
	92: v_o = 20;
	93: v_o = 20;
	94: v_o = 21;
	95: v_o = 22;
	96: v_o = 22;
	97: v_o = 23;
	98: v_o = 23;
	99: v_o = 24;
	100: v_o = 25;
	101: v_o = 25;
	102: v_o = 26;
	103: v_o = 26;
	104: v_o = 27;
	105: v_o = 28;
	106: v_o = 28;
	107: v_o = 29;
	108: v_o = 30;
	109: v_o = 30;
	110: v_o = 31;
	111: v_o = 32;
	112: v_o = 33;
	113: v_o = 33;
	114: v_o = 34;
	115: v_o = 35;
	116: v_o = 36;
	117: v_o = 36;
	118: v_o = 37;
	119: v_o = 38;
	120: v_o = 39;
	121: v_o = 40;
	122: v_o = 40;
	123: v_o = 41;
	124: v_o = 42;
	125: v_o = 43;
	126: v_o = 44;
	127: v_o = 45;
	128: v_o = 46;
	129: v_o = 46;
	130: v_o = 47;
	131: v_o = 48;
	132: v_o = 49;
	133: v_o = 50;
	134: v_o = 51;
	135: v_o = 52;
	136: v_o = 53;
	137: v_o = 54;
	138: v_o = 55;
	139: v_o = 56;
	140: v_o = 57;
	141: v_o = 58;
	142: v_o = 59;
	143: v_o = 60;
	144: v_o = 61;
	145: v_o = 62;
	146: v_o = 63;
	147: v_o = 64;
	148: v_o = 65;
	149: v_o = 67;
	150: v_o = 68;
	151: v_o = 69;
	152: v_o = 70;
	153: v_o = 71;
	154: v_o = 72;
	155: v_o = 73;
	156: v_o = 75;
	157: v_o = 76;
	158: v_o = 77;
	159: v_o = 78;
	160: v_o = 80;
	161: v_o = 81;
	162: v_o = 82;
	163: v_o = 83;
	164: v_o = 85;
	165: v_o = 86;
	166: v_o = 87;
	167: v_o = 89;
	168: v_o = 90;
	169: v_o = 91;
	170: v_o = 93;
	171: v_o = 94;
	172: v_o = 95;
	173: v_o = 97;
	174: v_o = 98;
	175: v_o = 99;
	176: v_o = 101;
	177: v_o = 102;
	178: v_o = 104;
	179: v_o = 105;
	180: v_o = 107;
	181: v_o = 108;
	182: v_o = 110;
	183: v_o = 111;
	184: v_o = 113;
	185: v_o = 114;
	186: v_o = 116;
	187: v_o = 117;
	188: v_o = 119;
	189: v_o = 121;
	190: v_o = 122;
	191: v_o = 124;
	192: v_o = 125;
	193: v_o = 127;
	194: v_o = 129;
	195: v_o = 130;
	196: v_o = 132;
	197: v_o = 134;
	198: v_o = 135;
	199: v_o = 137;
	200: v_o = 139;
	201: v_o = 141;
	202: v_o = 142;
	203: v_o = 144;
	204: v_o = 146;
	205: v_o = 148;
	206: v_o = 150;
	207: v_o = 151;
	208: v_o = 153;
	209: v_o = 155;
	210: v_o = 157;
	211: v_o = 159;
	212: v_o = 161;
	213: v_o = 163;
	214: v_o = 165;
	215: v_o = 166;
	216: v_o = 168;
	217: v_o = 170;
	218: v_o = 172;
	219: v_o = 174;
	220: v_o = 176;
	221: v_o = 178;
	222: v_o = 180;
	223: v_o = 182;
	224: v_o = 184;
	225: v_o = 186;
	226: v_o = 189;
	227: v_o = 191;
	228: v_o = 193;
	229: v_o = 195;
	230: v_o = 197;
	231: v_o = 199;
	232: v_o = 201;
	233: v_o = 204;
	234: v_o = 206;
	235: v_o = 208;
	236: v_o = 210;
	237: v_o = 212;
	238: v_o = 215;
	239: v_o = 217;
	240: v_o = 219;
	241: v_o = 221;
	242: v_o = 224;
	243: v_o = 226;
	244: v_o = 228;
	245: v_o = 231;
	246: v_o = 233;
	247: v_o = 235;
	248: v_o = 238;
	249: v_o = 240;
	250: v_o = 243;
	251: v_o = 245;
	252: v_o = 248;
	253: v_o = 250;
	254: v_o = 253;
	255: v_o = 255;
	default: v_o = 0;
	endcase
end

endmodule
