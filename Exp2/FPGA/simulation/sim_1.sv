`timescale 1ns/1ps

module Oscilador_tb;

    // Señales del DUT
    logic       clk;
    logic       reset;
    logic [1:0] sw;
    logic [7:0] sine_out;

    // Instancia del módulo a probar
    Oscilador dut (
        .clk      (clk),
        .reset    (reset),
        .sw       (sw),
        .sine_out (sine_out)
    );

    // ============================================
    // Clock de 100 MHz
    // Período = 10 ns
    // ============================================
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // ============================================
    // Estímulos
    // ============================================
    initial begin

        // Valores iniciales
        reset = 1'b1;
        sw    = 2'b00;

        // Mantener reset durante algunos ciclos
        repeat (5) @(posedge clk);

        // Liberar reset
        reset = 1'b0;

        // ========================================
        // sw = 00 durante 10 ms
        // ========================================
        sw = 2'b00;
        #10ms;

        // ========================================
        // sw = 01 durante 10 ms
        // ========================================
        sw = 2'b01;
        #10ms;

        // ========================================
        // sw = 10 durante 10 ms
        // ========================================
        sw = 2'b10;
        #10ms;

        // ========================================
        // sw = 11 durante 10 ms
        // ========================================
        sw = 2'b11;
        #10ms;

        // Terminar simulación
        $finish;
    end

endmodule