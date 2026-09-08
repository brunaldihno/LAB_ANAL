`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.09.2026 18:18:13
// Design Name: 
// Module Name: addres_counter
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


module addres_counter (
    input logic clk,
    input logic reset,
    input logic tick,
    output logic [7:0] adress
    );
    always_ff @(posedge clk)begin
        if (reset) begin
            adress <= 0;
        end
        else if (tick) begin
            adress <= adress + 1;
        end
    end
endmodule
