`timescale 1ns / 1ps

module clk_div #(
    parameter int LIMIT = 100,
    parameter logic RESET_STATE = 1'b0
) (
    input  logic in_clk,
    input  logic reset,
    output logic out_clk
);

    logic [$clog2(LIMIT)-1:0] counter;

    always_ff @(posedge in_clk) begin
        if (reset) begin
            counter <= 0;
            out_clk <= RESET_STATE;
        end
        else if (counter < LIMIT-1) begin
            counter <= counter + 1;
        end
        else begin
            counter <= 0;
            out_clk <= ~out_clk;
        end
    end

endmodule