`timescale 1ns/1ps

module uart_rx_tb;

    logic       clk;
    logic       rx;
    logic       reset;
    logic [7:0] data;
    logic       ready;

    // ============================================================
    // DUT
    // ============================================================
    uart_rx dut (
        .clk   (clk),
        .rx    (rx),
        .reset (reset),
        .data  (data),
        .ready (ready)
    );

    // ============================================================
    // Clock: 100 MHz -> 10 ns
    // ============================================================
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

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

        // Valores iniciales
        rx    = 1'b1;
        reset = 1'b1;

        // Reset
        repeat (10) @(posedge clk);
        reset = 1'b0;

        // Esperar un poco después del reset
        repeat (10) @(posedge clk);

        // Enviar 0xA5
        $display("[%0t] Enviando byte 0xA5", $time);
        uart_send_byte(8'h61);

        // Esperar a que el receptor indique que está listo
        wait (ready);

        // Esperar un poco y terminar
        repeat (20) @(posedge clk);

        $finish;
    end

endmodule