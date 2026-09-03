`timescale 1ns / 1ps

module tb_clk_div;

    // Señales del testbench
    logic in_clk;
    logic reset;
    logic out_clk;

    // Instancia del DUT (Device Under Test)
    clk_div #(
        .LIMIT(4),
        .RESET_STATE(1'b0)
    ) dut (
        .in_clk(in_clk),
        .reset(reset),
        .out_clk(out_clk)
    );

    // Generador de clock
    initial begin
        in_clk = 1'b0;

        forever begin
            #5 in_clk = ~in_clk;
        end
    end

    // Generador de reset y duración de la simulación
    initial begin
        reset = 1'b1;

        #20;

        reset = 1'b0;

        #3000;

        $finish;
    end

endmodule