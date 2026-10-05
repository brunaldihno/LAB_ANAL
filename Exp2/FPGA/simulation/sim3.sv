`timescale 1ns / 1ps

module tb_maestro;

    logic clk;
    logic reset;
    logic [1:0] switch;
    logic boton;

    logic pwm_out;
    logic [3:0] enables;
    logic punto;
    logic [7:0] segments;

    // Instancia del módulo maestro
    maestro uut (
        .clk(clk),
        .reset(reset),
        .switch(switch),
        .boton(boton),
        .pwm_out(pwm_out),
        .enables(enables),
        .punto(punto),
        .segments(segments)
    );

    // Reloj de 100 MHz (periodo de 10 ns)
    initial clk = 0;
    always #5 clk = ~clk;

    // Secuencia de estímulos
    initial begin
        // Valores iniciales
        reset = 1;
        boton = 1;
        switch = 2'b00;

        // Reset activo solo al principio
        #20;
        reset = 0;

        // Recorrer los 4 estados de sw, 5 ms cada uno
        switch = 2'b00;
        #50_000_000;

        switch = 2'b01;
        #50_000_000;

        switch = 2'b10;
        #50_000_000;

        switch = 2'b11;
        #50_000_000;

        // Boton pasa a LOW
        boton = 0;

        // 1 ms adicional de simulación
        #20_000_000;

        $finish;
    end

endmodule