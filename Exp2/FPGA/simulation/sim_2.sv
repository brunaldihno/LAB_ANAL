`timescale 1ns/1ps

module Sierra_tb;

    // Señales del DUT
    logic       clk;
    logic       reset;
    logic [7:0] saw_out;

    // Instancia del módulo a probar
    Sierra dut (
        .clk      (clk),
        .reset    (reset),
        .saw_out (saw_out)
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

        // Mantener reset durante algunos ciclos
        repeat (5) @(posedge clk);

        // Liberar reset
        reset = 1'b0;

        // ========================================
        // sw = 00 durante 10 ms
        // ========================================
        #10ms;

        // Terminar simulación
        $finish;
    end

endmodule