`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.09.2026 15:35:05
// Design Name: 
// Module Name: clk_divider
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


module clk_divider #(parameter int WIDTH = 32)(
    input logic clk,
    input logic reset,
    input logic [31:0] incremento,
    output logic tick
    );
    
    logic [WIDTH-1:0] acumulador;
    logic [WIDTH-1:0] acumulador_sig;
    
    assign acumulador_sig = acumulador + incremento;

    always_ff @(posedge clk) begin
        if (reset) begin
            acumulador <= 0;
            tick <= 0;
        end
        else begin
            acumulador <= acumulador + incremento;
            tick <= !acumulador[WIDTH-1] && acumulador_sig[WIDTH-1];
        end
    end
endmodule
