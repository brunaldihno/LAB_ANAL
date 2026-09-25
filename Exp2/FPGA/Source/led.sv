`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.09.2026 13:10:22
// Design Name: 
// Module Name: maestro
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


module led(
    input logic clk,
    input logic reset,
    input logic [1:0] switch,
    output logic [3:0] enables,
    output logic [7:0] segments
    );
    logic [16:0] counter;
    logic [1:0] digit;
    
    always_ff @(posedge clk) begin
        if (reset) begin
            counter <= 0;
            digit <= 0;
        end else if (counter == 49_999) begin
            counter <= 0;
            digit <= digit + 1;
            end
        else begin
            counter <= counter + 1;
        end
            
    end
    logic [3:0] d3, d2, d1, d0;

    always_comb begin
        case(switch)
            2'b00: begin // 0220
                d3 = 0;
                d2 = 2;
                d1 = 2;
                d0 = 0;
            end
            2'b01: begin // 0392
                d3 = 0;
                d2 = 3;
                d1 = 9;
                d0 = 2;
            end
            2'b10: begin // 0554
                d3 = 0;
                d2 = 5;
                d1 = 5;
                d0 = 4;
            end
            2'b11: begin // 0740
                d3 = 0;
                d2 = 7;
                d1 = 4;
                d0 = 0;
            end
        endcase

    end

    logic [3:0] current_digit;
    always_comb begin

        case(digit)
            2'b00: begin
                enables = 4'b1110;
                current_digit = d0;
            end
            2'b01: begin
                enables = 4'b1101;
                current_digit = d1;
            end
            2'b10: begin
                enables = 4'b1011;
                current_digit = d2;
            end
            2'b11: begin
                enables = 4'b0111;
                current_digit = d3;
            end
        endcase
    end
    
    always_comb begin
        case(current_digit)
            4'd0: segments = 8'b11000000;
            4'd1: segments = 8'b11111001;
            4'd2: segments = 8'b10100100;
            4'd3: segments = 8'b10110000;
            4'd4: segments = 8'b10011001;
            4'd5: segments = 8'b10010010;
            4'd6: segments = 8'b10000010;
            4'd7: segments = 8'b11111000;
            4'd8: segments = 8'b10000000;
            4'd9: segments = 8'b10010000;
            default: segments = 8'b11111111;
        endcase
    end


endmodule
