`timescale 1ns / 1ps

module uart_rx (
    input  logic       clk,
    input  logic       rx,
    input  logic       reset,
    output logic [7:0] data,
    output logic       ready
);
    
    logic           active;
    int             indice;
    logic [7:0]     curr_data;
    logic [31:0]    inc;
    logic           tick;

    clk_divider #() CLK(
        .clk(clk),
        .reset(~active),
        .incremento(inc),
        .tick(tick)
    );

    always_ff @(posedge clk) begin
        if (reset) begin
            ready     <= 1'b0;
            active    <= 1'b0;
            indice    <= 0;
            inc       <= 32'd4947802; // 115200Hz
            curr_data <= 8'b0;
            data      <= 8'b0;
        end
        else if (!active && !rx) begin
            ready  <= 1'b0;
            active <= 1'b1;
            inc    <= 32'd4947802;
        end
        else if (tick) begin

            if (indice == 0) begin
                ready <= 1'b0;
        
                if (rx) begin
                    active <= 1'b0;
                end
                else begin
                    inc    <= 32'd9895605; // 115200*2Hz
                    indice <= indice + 1;
                end
            end
        
            else if (indice < 18) begin
                // Guardar datos cada dos ticks: 2, 4, 6, ..., 16
                if ((indice >= 2) && (indice <= 16) && (indice % 2 == 0)) begin
                    curr_data[(indice / 2) - 1] <= rx;
                end
        
                indice <= indice + 1;
                ready <= 1'b0;
            end
        
            else if (indice == 18) begin
                if (rx) begin
                    data   <= curr_data;
                    ready  <= 1'b1;
                    active <= 1'b0;
                    indice <= 0;
                end
                else begin
                    ready  <= 1'b0;
                    active <= 1'b0;
                    indice <= 0;
                end
            end
        end 
        else begin
            ready    <= 1'b0;
        end
    end

endmodule