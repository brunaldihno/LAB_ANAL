
`timescale 1ns/1ps

module tb_sine_generator;

    // Entradas
    logic        sys_clk;
    logic        reset;
    logic [7:0]  data_in;

    // Salida
    logic [7:0]  data_out;

    // DUT
    sine_generator dut (
        .sys_clk  (sys_clk),
        .reset    (reset),
        .data_in  (data_in),
        .data_out (data_out)
    );

    // Reloj de 100 MHz: período = 10 ns
    initial begin
        sys_clk = 0;
        forever #5 sys_clk = ~sys_clk;
    end

    // Estímulos
    initial begin

        // Valores iniciales
        reset   = 1'b1;
        data_in = 8'h16;

        // Mantener reset durante 5 ciclos
        repeat (5) @(posedge sys_clk);

        // Liberar reset
        @(negedge sys_clk);
        reset = 1'b0;

        // Mantener simulación durante 10000 ciclos
        # 7215000;
        data_in = 8'h5D;
        # 2145000;
        data_in = 8'hAA;
        # 500000;
        $finish;
    end

endmodule
