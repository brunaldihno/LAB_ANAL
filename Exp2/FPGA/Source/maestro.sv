`timescale 1ns/1ps

module maestro(
    input logic clk,
    input logic reset,
    input logic [1:0] sw,
    input logic [1:0] boton,
    input logic [7:0] audio_externo,
    output logic pwm_out,
    output logic [3:0] enables,
    output logic [7:0] segments
    );

    logic [7:0] audio_local;
    logic [7:0] diente;
    logic [7:0] audio_seleccionado;

    oscilador OSC(
        .clk(clk),
        .reset(reset),
        .sw(sw),
        .sine_out(audio_local)
    );

    sierra S(
        .clk(clk),
        .reset(reset),
        .saw_out(diente)
    );

    mux MUX(
        .boton(boton),
        .audio_prueba(audio_local),
        .audio_real(audio_externo),
        .audio_salida(audio_seleccionado)
    );
    comparator COM(
        .audio(audio_seleccionado),
        .portadora(diente),
        .pwm_out(pwm_out) 
    );
    
    led LEDS(
        .clk(clk),
        .reset(reset),
        .switch(sw),
        .enables(enables),
        .segments(segments)
    );

endmodule

