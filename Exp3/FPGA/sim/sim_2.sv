
`timescale 1ns / 1ps

module tb_phase_acumlator;

    // Entradas
    logic        sys_clk;
    logic        reset;
    logic        tick;
    logic [3:0]  increment;
    logic [15:0] frac;

    // Salida
    logic [3:0] inc;

    // Instancia del DUT
    phase_acumlator DUT (
        .sys_clk  (sys_clk),
        .reset    (reset),
        .tick     (tick),
        .increment(increment),
        .frac     (frac),
        .inc      (inc)
    );

    // Generador de clock: periodo de 10 ns
    initial begin
        sys_clk = 0;
        forever #5 sys_clk = ~sys_clk;
    end

    // Estímulos
    initial begin
        reset     = 1;
        tick      = 0;
        increment = 4'd3;
        frac      = 16'd36045;

        // Mantener reset durante 2 ciclos
        repeat (2) @(posedge sys_clk);
        reset = 0;

        // Activar tick durante un ciclo cada 10 ciclos
        forever begin
            repeat (9) @(negedge sys_clk);
            tick = 1;

            @(negedge sys_clk);
            tick = 0;
        end
    end

    // Tiempo de simulación
    initial begin
        #10100;
        $finish;
    end

endmodule
