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


module Sierra
  #(parameter increment = 274877907)
  ( input logic clk,
    input logic reset,
    output logic [7:0] saw_out        
    );
    
    logic tick;
    
    clk_divider #() CLK(
        .clk(clk),
        .reset(reset),
        .incremento(increment),
        .tick(tick)
    );
    
    addres_counter AC(
        .clk(clk),
        .reset(reset),
        .tick(tick),
        .adress(saw_out)
    );
    
endmodule