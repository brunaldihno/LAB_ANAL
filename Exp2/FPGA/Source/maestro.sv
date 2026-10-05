`timescale 1ns/1ps

module maestro(
    input logic clk,
    input logic reset,
    input logic [1:0] switch,
    input logic boton,
    input logic rx,
    output logic pwm_out,
    output logic [3:0] enables,
    output logic punto,
    output logic [6:0] segments,
    output logic [6:0] debug_leds
    );

    logic [7:0] audio_externo;
    logic [7:0] audio_local;
    logic [7:0] diente;
    logic [7:0] audio_seleccionado;
    logic [19:0] led_data;
    logic rx_ready;

    uart_rx RX(
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .data(audio_externo),
        .ready(rx_ready)
    );

    oscilador OSC(
        .clk(clk),
        .reset(reset),
        .switch(switch),
        .sine_out(audio_local)
    );

    sierra S(
        .clk(clk),
        .reset(reset),
        .saw_out(diente)
    );

    mux MUX(
        .clk(clk),
        .reset(reset),
        .boton(boton),
        .switch(switch),
        .audio_prueba(audio_local),
        .audio_real(audio_externo),
        .aud_ready(rx_ready),
        .audio_salida(audio_seleccionado),
        .led_data(led_data)
    );
    comparador COM(
        .audio(audio_seleccionado),
        .portadora(diente),
        .pwm_out(pwm_out) 
    );
    
    led_driver LED(
        .clk(clk),
        .reset(reset),
        .data(led_data),
        .segments(segments),
        .punto(punto),
        .enables(enables)
    );
    
    assign debug_leds[0] = 1'b1;
    assign debug_leds[1] = 1'b1;
    assign debug_leds[2] = 1'b1;
    assign debug_leds[5] = 1'b1;
    assign debug_leds[6] = 1'b1;

    assign debug_leds[3] = rx;
    
    assign debug_leds[4] = ~rx;

endmodule