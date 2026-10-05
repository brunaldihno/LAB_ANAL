`timescale 1ns/1ps

module maestr_rx_tb;

    logic clk;
    logic rx;
    logic reset;
    logic [1:0] switch;
    logic boton;

    logic pwm_out;
    logic [3:0] enables;
    logic punto;
    logic [6:0] segments;

    // Instancia del módulo maestro
    maestro uut (
        .clk(clk),
        .reset(reset),
        .switch(switch),
        .rx(rx),
        .boton(boton),
        .pwm_out(pwm_out),
        .enables(enables),
        .punto(punto),
        .segments(segments)
    );

    // Reloj de 100 MHz (periodo de 10 ns)
    initial clk = 0;
    always #5 clk = ~clk;

    // ============================================================
    // Parámetros UART
    // ============================================================
    localparam time BIT_TIME = 1s / 115200;

    // ============================================================
    // Tarea para transmitir un byte UART 8N1
    // ============================================================
    task automatic uart_send_byte(input logic [7:0] tx_byte);
        integer i;

        begin
            // Línea en idle
            rx = 1'b1;
            #(BIT_TIME);

            // Start bit
            rx = 1'b0;
            #(BIT_TIME);

            // 8 bits de datos, LSB first
            for (i = 0; i < 8; i++) begin
                rx = tx_byte[i];
                #(BIT_TIME);
            end

            // Stop bit
            rx = 1'b1;
            #(BIT_TIME);

            // Idle
            rx = 1'b1;
        end
    endtask

    // ============================================================
    // Test
    // ============================================================
    initial begin

        reset = 1;
        boton = 0;
        switch = 2'b00;// Valores iniciales
        rx    = 1'b1;

        // Reset
        repeat (10) @(posedge clk);
        reset = 1'b0;

        // Esperar un poco después del reset
        repeat (10) @(posedge clk);

        // Enviar 0xA5
        $display("[%0t] Enviando byte 0x61", $time);
        uart_send_byte(8'h02);

        // Esperar un poco y terminar
        repeat (20) @(posedge clk);
    end

endmodule