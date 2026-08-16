`timescale 1ns / 1ps

module UART_RX (
    input  logic       clk,
    input  logic       clk_UART,
    input  logic       RX,
    input  logic       reset,
    output logic [7:0] data,
    output logic       ready,
    output logic       active
);

    logic      clk_prev;
    int        indice;
    logic [7:0] curr_data;

    always_ff @(posedge clk) begin
        if (reset) begin
            ready     <= 1'b0;
            active    <= 1'b0;
            indice    <= 0;
            clk_prev  <= 1'b0;
            curr_data <= 8'b0;
            data      <= 8'b0;
        end
        else if (!active && !RX) begin
            ready  <= 1'b0;
            active <= 1'b1;
        end
        else if (clk_UART && !clk_prev) begin
            clk_prev <= clk_UART;

            if (indice == 0) begin
                ready <= 1'b0;

                if (RX) begin
                    active <= 1'b0;
                end
                else begin
                    indice <= indice + 1;
                end
            end
            else if ((indice > 0) && (indice < 9)) begin
                ready <= 1'b0;
                curr_data[indice-1] <= RX;
                indice <= indice + 1;
            end
            else if (indice == 9) begin
                data   <= curr_data;
                ready  <= 1'b1;
                active <= 1'b0;
                indice <= 0;
            end
        end
        else begin
            clk_prev <= clk_UART;
            ready    <= 1'b0;
        end
    end

endmodule