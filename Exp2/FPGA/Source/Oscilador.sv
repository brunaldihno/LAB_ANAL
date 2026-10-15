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


module oscilador(
    input logic clk,
    input logic reset,
    input logic [1:0] switch,
    input logic [2:0] amp,
    output logic [7:0] sine_out        
    );
    
    logic tick;
    logic [7:0] address;
    logic [31:0] incremento;
    
    always_comb begin
        case (switch)
            2'b00: incremento = 2418926;
            2'b01: incremento = 4309976;
            2'b10: incremento = 6095583;
            2'b11: incremento = 8136166;
        endcase
    end
    
   logic [7:0] sine_out1;
   logic [7:0] sine_out2;
   logic [7:0] sine_out3;
   logic [7:0] sine_out4;
   logic [8:0] pre_sine_out;
    
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
    
    data_sin1 DS1 (
        .address(address),
        .sine_table(sine_out1)
    );
    
    data_sin2 DS2 (
        .address(address),
        .sine_table(sine_out2)
    );
    
    data_sin3 DS3 (
        .address(address),
        .sine_table(sine_out3)
    );
    
    data_sin4 DS4 (
        .address(address),
        .sine_table(sine_out4)
    );
    
    always_ff @(posedge clk) begin
        case(amp)
            3'd0: sine_out <= sine_out1;
            3'd1: sine_out <= sine_out2;
            3'd2: sine_out <= sine_out3;
            3'd3: sine_out <= sine_out4;
            3'd4: sine_out <= ({1'b0, sine_out1} + 9'd128) >> 1;
            3'd5: sine_out <= ({1'b0, sine_out2} + 9'd128) >> 1;
            3'd6: sine_out <= ({1'b0, sine_out3} + 9'd128) >> 1;
            3'd7: sine_out <= ({1'b0, sine_out4} + 9'd128) >> 1;
        endcase
    end
    
endmodule