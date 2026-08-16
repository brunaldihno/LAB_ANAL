`timescale 1ns / 1ps

module LED_driver (
    input  logic        clk,
    input  logic [15:0] data,
    output logic [6:0]  segments,
    output logic        punto,
    output logic [3:0]  enables
);

    logic [1:0] state;

    logic [3:0] decena;
    logic [3:0] unidad;
    logic [3:0] decima;
    logic [3:0] centecima;

    function automatic logic [6:0] seg_decode(input logic [3:0] x);
        case (x)
            4'h0: seg_decode = 7'b1000000;
            4'h1: seg_decode = 7'b1111001;
            4'h2: seg_decode = 7'b0100100;
            4'h3: seg_decode = 7'b0110000;
            4'h4: seg_decode = 7'b0011001;
            4'h5: seg_decode = 7'b0010010;
            4'h6: seg_decode = 7'b0000010;
            4'h7: seg_decode = 7'b1111000;
            4'h8: seg_decode = 7'b0000000;
            4'h9: seg_decode = 7'b0010000;
            4'ha: seg_decode = 7'b0001000;
            4'hb: seg_decode = 7'b0000011;
            4'hc: seg_decode = 7'b1000110;
            4'hd: seg_decode = 7'b0100001;
            4'he: seg_decode = 7'b0000110;
            4'hf: seg_decode = 7'b0001110;
            default: seg_decode = 7'b1111111;
        endcase
    endfunction

    always_ff @(posedge clk) begin

        decena    <= data[15:12];
        unidad    <= data[11:8];
        decima    <= data[7:4];
        centecima <= data[3:0];

        case (state)

            2'b00: begin
                enables <= 4'b0111;
                punto <= 1;
                segments <= seg_decode(decena);
            end

            2'b01: begin
                enables <= 4'b1011;
                punto <= 0;
                segments <= seg_decode(unidad);
            end

            2'b10: begin
                enables <= 4'b1101;
                punto <= 1;
                segments <= seg_decode(decima);
            end

            2'b11: begin
                enables <= 4'b1110;
                punto <= 1;
                segments <= seg_decode(centecima);
            end

        endcase

        state <= state + 1'b1;
 
    end

endmodule