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
    input logic clk,
    input logic reset,
    input logic boton,
    input logic [1:0] switch,
    input logic [7:0] audio_prueba,
    input logic [7:0] audio_real,
    input logic aud_ready,
    output logic [7:0] audio_salida,
    output logic [19:0] led_data
    );
    
    logic [7:0] data_real;
    logic [19:0] freq_data;
    
    always_comb begin
        case(switch)
            2'b00: begin // 220.0
                freq_data <= 20'b11010010001000000000;
            end
            2'b01: begin // 391.9
                freq_data <= 20'b11010011100100011001;
            end
            2'b10: begin // 554.3
                freq_data <= 20'b11010101010101000011;
            end
            2'b11: begin // 739.9
                freq_data <= 20'b11010111001110011001;
            end
        endcase
    end
    
   always_ff @(posedge clk) begin
        if (reset) begin
            audio_salida = 8'b10000000; // 128
            led_data = 20'b0000000000000000;  // 0.0.0.0.
        end
        
        else begin
            if (boton) begin // audio interno
                led_data = freq_data;
                audio_salida <= audio_prueba;
            end
            else begin // audio externo
                led_data = 20'b11111111111011101101; // FEEd
                audio_salida <= data_real;
                if (aud_ready) begin
                    data_real <= audio_real;
                end
            end
        end
   end
endmodule