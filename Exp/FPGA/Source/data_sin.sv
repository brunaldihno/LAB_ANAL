`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.09.2026 06:19:01
// Design Name: 
// Module Name: data_sin
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module data_sin(
    input logic [7:0] address, 
    output logic [7:0] sine_table
    );  
    
    always_comb begin
        case(address)
            8'd  0: sine_table = 8'd128;

            8'd  1: sine_table = 8'd131;

            8'd  2: sine_table = 8'd134;

            8'd  3: sine_table = 8'd137;

            8'd  4: sine_table = 8'd140;

            8'd  5: sine_table = 8'd143;

            8'd  6: sine_table = 8'd146;

            8'd  7: sine_table = 8'd149;

            8'd  8: sine_table = 8'd152;

            8'd  9: sine_table = 8'd156;

            8'd 10: sine_table = 8'd159;

            8'd 11: sine_table = 8'd162;

            8'd 12: sine_table = 8'd165;

            8'd 13: sine_table = 8'd168;

            8'd 14: sine_table = 8'd171;

            8'd 15: sine_table = 8'd174;

            8'd 16: sine_table = 8'd176;

            8'd 17: sine_table = 8'd179;

            8'd 18: sine_table = 8'd182;

            8'd 19: sine_table = 8'd185;

            8'd 20: sine_table = 8'd188;

            8'd 21: sine_table = 8'd191;

            8'd 22: sine_table = 8'd193;

            8'd 23: sine_table = 8'd196;

            8'd 24: sine_table = 8'd199;

            8'd 25: sine_table = 8'd201;

            8'd 26: sine_table = 8'd204;

            8'd 27: sine_table = 8'd206;

            8'd 28: sine_table = 8'd209;

            8'd 29: sine_table = 8'd211;

            8'd 30: sine_table = 8'd213;

            8'd 31: sine_table = 8'd216;

            8'd 32: sine_table = 8'd218;

            8'd 33: sine_table = 8'd220;

            8'd 34: sine_table = 8'd222;

            8'd 35: sine_table = 8'd224;

            8'd 36: sine_table = 8'd226;

            8'd 37: sine_table = 8'd228;

            8'd 38: sine_table = 8'd230;

            8'd 39: sine_table = 8'd232;

            8'd 40: sine_table = 8'd234;

            8'd 41: sine_table = 8'd235;

            8'd 42: sine_table = 8'd237;

            8'd 43: sine_table = 8'd239;

            8'd 44: sine_table = 8'd240;

            8'd 45: sine_table = 8'd242;

            8'd 46: sine_table = 8'd243;

            8'd 47: sine_table = 8'd244;

            8'd 48: sine_table = 8'd246;

            8'd 49: sine_table = 8'd247;

            8'd 50: sine_table = 8'd248;

            8'd 51: sine_table = 8'd249;

            8'd 52: sine_table = 8'd250;

            8'd 53: sine_table = 8'd251;

            8'd 54: sine_table = 8'd251;

            8'd 55: sine_table = 8'd252;

            8'd 56: sine_table = 8'd253;

            8'd 57: sine_table = 8'd253;

            8'd 58: sine_table = 8'd254;

            8'd 59: sine_table = 8'd254;

            8'd 60: sine_table = 8'd254;

            8'd 61: sine_table = 8'd255;

            8'd 62: sine_table = 8'd255;

            8'd 63: sine_table = 8'd255;

            8'd 64: sine_table = 8'd255;

            8'd 65: sine_table = 8'd255;

            8'd 66: sine_table = 8'd255;

            8'd 67: sine_table = 8'd255;

            8'd 68: sine_table = 8'd254;

            8'd 69: sine_table = 8'd254;

            8'd 70: sine_table = 8'd253;

            8'd 71: sine_table = 8'd253;

            8'd 72: sine_table = 8'd252;

            8'd 73: sine_table = 8'd252;

            8'd 74: sine_table = 8'd251;

            8'd 75: sine_table = 8'd250;

            8'd 76: sine_table = 8'd249;

            8'd 77: sine_table = 8'd248;

            8'd 78: sine_table = 8'd247;

            8'd 79: sine_table = 8'd246;

            8'd 80: sine_table = 8'd245;

            8'd 81: sine_table = 8'd244;

            8'd 82: sine_table = 8'd242;

            8'd 83: sine_table = 8'd241;

            8'd 84: sine_table = 8'd239;

            8'd 85: sine_table = 8'd238;

            8'd 86: sine_table = 8'd236;

            8'd 87: sine_table = 8'd235;

            8'd 88: sine_table = 8'd233;

            8'd 89: sine_table = 8'd231;

            8'd 90: sine_table = 8'd229;

            8'd 91: sine_table = 8'd227;

            8'd 92: sine_table = 8'd225;

            8'd 93: sine_table = 8'd223;

            8'd 94: sine_table = 8'd221;

            8'd 95: sine_table = 8'd219;

            8'd 96: sine_table = 8'd217;

            8'd 97: sine_table = 8'd215;

            8'd 98: sine_table = 8'd212;

            8'd 99: sine_table = 8'd210;

            8'd100: sine_table = 8'd207;

            8'd101: sine_table = 8'd205;

            8'd102: sine_table = 8'd202;

            8'd103: sine_table = 8'd200;

            8'd104: sine_table = 8'd197;

            8'd105: sine_table = 8'd195;

            8'd106: sine_table = 8'd192;

            8'd107: sine_table = 8'd189;

            8'd108: sine_table = 8'd186;

            8'd109: sine_table = 8'd184;

            8'd110: sine_table = 8'd181;

            8'd111: sine_table = 8'd178;

            8'd112: sine_table = 8'd175;

            8'd113: sine_table = 8'd172;

            8'd114: sine_table = 8'd169;

            8'd115: sine_table = 8'd166;

            8'd116: sine_table = 8'd163;

            8'd117: sine_table = 8'd160;

            8'd118: sine_table = 8'd157;

            8'd119: sine_table = 8'd154;

            8'd120: sine_table = 8'd151;

            8'd121: sine_table = 8'd148;

            8'd122: sine_table = 8'd145;

            8'd123: sine_table = 8'd142;

            8'd124: sine_table = 8'd138;

            8'd125: sine_table = 8'd135;

            8'd126: sine_table = 8'd132;

            8'd127: sine_table = 8'd129;

            8'd128: sine_table = 8'd126;

            8'd129: sine_table = 8'd123;

            8'd130: sine_table = 8'd120;

            8'd131: sine_table = 8'd117;

            8'd132: sine_table = 8'd113;

            8'd133: sine_table = 8'd110;

            8'd134: sine_table = 8'd107;

            8'd135: sine_table = 8'd104;

            8'd136: sine_table = 8'd101;

            8'd137: sine_table = 8'd98;

            8'd138: sine_table = 8'd95;

            8'd139: sine_table = 8'd92;

            8'd140: sine_table = 8'd89;

            8'd141: sine_table = 8'd86;

            8'd142: sine_table = 8'd83;

            8'd143: sine_table = 8'd80;

            8'd144: sine_table = 8'd77;

            8'd145: sine_table = 8'd74;

            8'd146: sine_table = 8'd71;

            8'd147: sine_table = 8'd69;

            8'd148: sine_table = 8'd66;

            8'd149: sine_table = 8'd63;

            8'd150: sine_table = 8'd60;

            8'd151: sine_table = 8'd58;

            8'd152: sine_table = 8'd55;

            8'd153: sine_table = 8'd53;

            8'd154: sine_table = 8'd50;

            8'd155: sine_table = 8'd48;

            8'd156: sine_table = 8'd45;

            8'd157: sine_table = 8'd43;

            8'd158: sine_table = 8'd40;

            8'd159: sine_table = 8'd38;

            8'd160: sine_table = 8'd36;

            8'd161: sine_table = 8'd34;

            8'd162: sine_table = 8'd32;

            8'd163: sine_table = 8'd30;

            8'd164: sine_table = 8'd28;

            8'd165: sine_table = 8'd26;

            8'd166: sine_table = 8'd24;

            8'd167: sine_table = 8'd22;

            8'd168: sine_table = 8'd20;

            8'd169: sine_table = 8'd19;

            8'd170: sine_table = 8'd17;

            8'd171: sine_table = 8'd16;

            8'd172: sine_table = 8'd14;

            8'd173: sine_table = 8'd13;

            8'd174: sine_table = 8'd11;

            8'd175: sine_table = 8'd10;

            8'd176: sine_table = 8'd9;

            8'd177: sine_table = 8'd8;

            8'd178: sine_table = 8'd7;

            8'd179: sine_table = 8'd6;

            8'd180: sine_table = 8'd5;

            8'd181: sine_table = 8'd4;

            8'd182: sine_table = 8'd3;

            8'd183: sine_table = 8'd3;

            8'd184: sine_table = 8'd2;

            8'd185: sine_table = 8'd2;

            8'd186: sine_table = 8'd1;

            8'd187: sine_table = 8'd1;

            8'd188: sine_table = 8'd0;

            8'd189: sine_table = 8'd0;

            8'd190: sine_table = 8'd0;

            8'd191: sine_table = 8'd0;

            8'd192: sine_table = 8'd0;

            8'd193: sine_table = 8'd0;

            8'd194: sine_table = 8'd0;

            8'd195: sine_table = 8'd1;

            8'd196: sine_table = 8'd1;

            8'd197: sine_table = 8'd1;

            8'd198: sine_table = 8'd2;

            8'd199: sine_table = 8'd2;

            8'd200: sine_table = 8'd3;

            8'd201: sine_table = 8'd4;

            8'd202: sine_table = 8'd4;

            8'd203: sine_table = 8'd5;

            8'd204: sine_table = 8'd6;

            8'd205: sine_table = 8'd7;

            8'd206: sine_table = 8'd8;

            8'd207: sine_table = 8'd9;

            8'd208: sine_table = 8'd11;

            8'd209: sine_table = 8'd12;

            8'd210: sine_table = 8'd13;

            8'd211: sine_table = 8'd15;

            8'd212: sine_table = 8'd16;

            8'd213: sine_table = 8'd18;

            8'd214: sine_table = 8'd20;

            8'd215: sine_table = 8'd21;

            8'd216: sine_table = 8'd23;

            8'd217: sine_table = 8'd25;

            8'd218: sine_table = 8'd27;

            8'd219: sine_table = 8'd29;

            8'd220: sine_table = 8'd31;

            8'd221: sine_table = 8'd33;

            8'd222: sine_table = 8'd35;

            8'd223: sine_table = 8'd37;

            8'd224: sine_table = 8'd39;

            8'd225: sine_table = 8'd42;

            8'd226: sine_table = 8'd44;

            8'd227: sine_table = 8'd46;

            8'd228: sine_table = 8'd49;

            8'd229: sine_table = 8'd51;

            8'd230: sine_table = 8'd54;

            8'd231: sine_table = 8'd56;

            8'd232: sine_table = 8'd59;

            8'd233: sine_table = 8'd62;

            8'd234: sine_table = 8'd64;

            8'd235: sine_table = 8'd67;

            8'd236: sine_table = 8'd70;

            8'd237: sine_table = 8'd73;

            8'd238: sine_table = 8'd76;

            8'd239: sine_table = 8'd79;

            8'd240: sine_table = 8'd81;

            8'd241: sine_table = 8'd84;

            8'd242: sine_table = 8'd87;

            8'd243: sine_table = 8'd90;

            8'd244: sine_table = 8'd93;

            8'd245: sine_table = 8'd96;

            8'd246: sine_table = 8'd99;

            8'd247: sine_table = 8'd103;

            8'd248: sine_table = 8'd106;

            8'd249: sine_table = 8'd109;

            8'd250: sine_table = 8'd112;

            8'd251: sine_table = 8'd115;

            8'd252: sine_table = 8'd118;

            8'd253: sine_table = 8'd121;

            8'd254: sine_table = 8'd124;

            8'd255: sine_table = 8'd127;
        endcase
    end    
endmodule
