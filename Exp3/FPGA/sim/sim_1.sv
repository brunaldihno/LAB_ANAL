`timescale 1ns/1ps

module Big_boss_tb;

    logic sys_clk;
    logic reset;
    logic PS2Clk;
    logic PS2Data;

    logic [6:0] seg;
    logic       dot;
    logic [3:0] en;
    
    logic JC;

    // Periodo de sys_clk = 10 ns -> 100 MHz
    localparam time SYS_CLK_PERIOD = 10ns;

    // Periodo de PS2Clk = 66.667 us -> 15 kHz
    localparam time PS2_CLK_PERIOD = 66_667ns;

    // Instancia del DUT
    Big_Boss dut (
        .sys_clk (sys_clk),
        .reset   (reset),
        .PS2Clk  (PS2Clk),
        .PS2Data (PS2Data),
        .seg     (seg),
        .dot     (dot),
        .en      (en),
        .JC      (JC)
    );

    // Reloj del sistema a 100 MHz
    initial begin
        sys_clk = 1'b0;
        forever #(SYS_CLK_PERIOD / 2) sys_clk = ~sys_clk;
    end

    // Envía una trama de 11 bits por PS/2.
    // Cada bit se transmite en un flanco de bajada.
    task automatic send_ps2_frame(input logic [10:0] frame);
        integer i;
        begin
            for (i = 10; i >= 0; i = i - 1) begin

                // Datos estables antes del flanco de bajada
                PS2Data = frame[i];

                // Mitad alta del reloj PS/2
                #(PS2_CLK_PERIOD / 2);

                // Flanco de bajada: el receptor lee el bit
                PS2Clk = 1'b0;

                #(PS2_CLK_PERIOD / 2);

                // Flanco de subida
                PS2Clk = 1'b1;
            end

            // Pausa entre tramas
            PS2Data = 1'b1;
            #(PS2_CLK_PERIOD);
        end
    endtask

    // Secuencia de prueba
    initial begin
        // Estado inicial
        reset   = 1'b1;
        PS2Clk  = 1'b1;
        PS2Data = 1'b1;

        // Mantener el reset durante algunos ciclos
        repeat (10) @(posedge sys_clk);
        reset = 1'b0;

        // Esperar a que el módulo esté preparado
        repeat (1000) @(posedge sys_clk);

        send_ps2_frame(11'b00111100011); // 1E
        
        # (30 * PS2_CLK_PERIOD);
        
        send_ps2_frame(11'b01011100011); // 1D
        
        # (30 * PS2_CLK_PERIOD);
        
        send_ps2_frame(11'b00000111111); // F0
        send_ps2_frame(11'b00111100011); // 1E
        
        # (30 * PS2_CLK_PERIOD);
        
        send_ps2_frame(11'b00000111111); // F0
        send_ps2_frame(11'b01011100011); // 1D
        
        # (30 * PS2_CLK_PERIOD);

        // Dejar tiempo para procesar la última trama
        #(10 * PS2_CLK_PERIOD);
        # (300 * PS2_CLK_PERIOD);
        $finish;
    end

endmodule