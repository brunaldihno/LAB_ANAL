`timescale 1ns / 1ps

module divisor #(
    parameter logic [15:0] DIVISOR = 16'd10
) (
    input  logic        clk,
    input  logic        reset,
    input  logic [15:0] data_in,
    output logic [3:0] unidades,
    output logic [15:0] resto,
    output logic        ready
);

    logic [15:0] data_in_prev;
    logic [15:0] aux;
    logic [3:0]  counter;

    always_ff @(posedge clk) begin
        if (reset) begin
            data_in_prev <= 16'b0;
            aux          <= data_in;
            counter      <= 4'b0;
            resto        <= 16'b0;
            unidades     <= 4'b0;
            ready        <= 1'b0;
        end
        else begin

            if (data_in_prev != data_in) begin
                counter      <= 0;
                ready        <= 1'b0;
                aux          <= data_in;
                data_in_prev <= data_in;
            end
            else begin

                if (aux >= DIVISOR) begin
                    aux     <= aux - DIVISOR;
                    counter <= counter + 1;
                end
                else begin
                    resto    <= aux;
                    unidades <= counter;
                    ready    <= 1'b1;
                end

            end
        end
    end

endmodule