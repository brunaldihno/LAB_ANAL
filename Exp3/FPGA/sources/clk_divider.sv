`timescale 1ns / 1ps

module clk_divider #(parameter int WIDTH = 32)(
    input logic sys_clk,
    input logic reset,
    input logic [31:0] incremento,
    output logic tick
    );
    
    logic [WIDTH-1:0] acumulador;
    logic [WIDTH-1:0] acumulador_sig;
    
    assign acumulador_sig = acumulador + incremento;

    always_ff @(posedge sys_clk) begin
        if (reset) begin
            acumulador <= 0;
            tick <= 0;
        end
        else begin
            acumulador <= acumulador + incremento;
            tick <= acumulador[WIDTH-1] && !acumulador_sig[WIDTH-1];
        end
    end
endmodule