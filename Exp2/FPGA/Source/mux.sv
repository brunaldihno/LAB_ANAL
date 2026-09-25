`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.09.2026 11:52:06
// Design Name: 
// Module Name: mux
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


module mux(
    input logic boton,
    input logic [7:0] audio_prueba,
    input logic [7:0] audio_real,
    output logic [7:0] audio_salida
    );
    assign audio_salida = boton ? audio_prueba : audio_real;
endmodule
