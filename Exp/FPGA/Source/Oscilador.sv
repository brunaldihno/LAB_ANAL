`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.09.2026 06:31:37
// Design Name: 
// Module Name: Oscilador
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


module Oscilador(
    input logic clk,
    input logic reset,
    input logic [1:0] sw,
    output logic [7:0] sine_out        
    );
    
    logic tick;
    logic [7:0] address;
    logic [31:0] incremento;
    
    always_comb begin
        case (sw)
            2'b00: incremento = 9423;
            2'b01: incremento = 16855;
            2'b10: incremento = 23816;
            2'b11: incremento = 31811;
        endcase
    end
    
    clk_divider #() CLK(
        .clk(clk),
        .reset(reset),
        .incremento(incremento),
        .tick(tick)
    );
    
    addres_counter AC(
        .clk(clk),
        .reset(reset),
        .tick(tick),
        .adress(address)
    );
    
    data_sin DS (
        .address(address),
        .sine_table(sine_out)
    );
    
endmodule
