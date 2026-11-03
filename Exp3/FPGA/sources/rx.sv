`timescale 1ns / 1ps

module p_rx (
    input  logic       sys_clk,
    input  logic       P2_clk,
    input  logic       P2_data,
    input  logic       reset,
    output logic [7:0] data,
    output logic       ready
);

    logic       P2_clk_prev;
    logic       active;
    int         indice;
    logic [7:0] curr_data;

    logic       activity;
    logic       timeout;

    clk_divider #() CLK(
        .sys_clk    (sys_clk),
        .reset      (activity),
        .incremento (214748), // 5kHz
        .tick       (timeout)
    );

    always_ff @(posedge sys_clk) begin
        if (reset) begin
            ready           <= 1'b0;
            indice          <= 0;
            P2_clk_prev     <= 1'b0;
            curr_data       <= 8'b0;
            active          <= 0;
            data            <= 8'b0;
        end
        else if (!active && !P2_clk && !P2_data) begin
            activity    <= 1;
            ready       <= 1'b0;
            active      <= 1'b1;
            P2_clk_prev <= 1'b0;
        end
        else if (!P2_clk && P2_clk_prev) begin
            activity    <= 1;
            P2_clk_prev <= P2_clk;

            if (indice < 8) begin
                ready <= 1'b0;
                curr_data[indice] <= P2_data;
                indice <= indice + 1;
            end
            
            else if (indice == 8) begin // 
                if (P2_data == ~^curr_data) begin
                    indice <= 9;
                end
                else begin
                    data   <= 8'b0;
                    active <= 1'b0;
                    indice <= 0;
                end
            end
            
            else if (indice == 9) begin // Stop
                if (P2_data) begin
                    data   <= curr_data;
                    ready  <= 1'b1;
                    active <= 1'b0;
                    indice <= 0;
                end
                else begin
                    data   <= 8'b0;
                    ready  <= 1'b0;
                    active <= 1'b0;
                    indice <= 0;
                end
            end
        end
        else begin
            activity    <= 0;
            P2_clk_prev <= P2_clk;
            ready       <= 1'b0;
            if (timeout) begin
                active  <= 1'b0;
                indice  <= 0;
            end
        end
    end

endmodule