`timescale 1ns / 1ps

module procesor (
    input  logic        in_clk,
    input  logic        reset,
    input  logic        boton,
    input  logic [3:0]  div_ready,
    input  logic [15:0] data_in,
    input  logic [3:0]  decena,
    input  logic [3:0]  unidad,
    input  logic [3:0]  decima,
    input  logic [3:0]  centecima,
    output logic [15:0] data_div,
    output logic [15:0] data_out
);

    
    typedef enum logic [2:0] {
        IDLE,
        CALC_A,
        CALC_B,
        CALC_C,
        CALC_D
    } state_t;
    
    state_t state;
    
    logic [31:0] a;
    logic [31:0] b;
    logic [31:0] c;

    always_ff @(posedge in_clk) begin
        if (reset) begin
            data_div <= 16'b0;
            data_out <= 16'b0;
            state    <= IDLE;
            a        <= 32'b0;
            b        <= 32'b0;
            c        <= 32'b0;
        end
        else begin
            if (&div_ready) begin
                data_out <= {decena, unidad, decima, centecima};
            end
            case (state)

                IDLE: begin

                    if (boton) begin
                        state <= CALC_A;
                    end

                    else begin
                        data_div <= data_in;
                    end

                end


                CALC_A: begin
                    a <= 32'd3300 - data_in;
                    state <= CALC_B;
                end


                CALC_B: begin
                    b <= a * 32'd34754;
                    state <= CALC_C;
                end


                CALC_C: begin
                    c <= b >> 14;
                    state <= CALC_D;
                end


                CALC_D: begin
                    data_div <= c + 32'd3000;
                    state <= IDLE;
                end
                
                default: begin
                    state <= IDLE;
                end


            endcase

        end
    end

endmodule