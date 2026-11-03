`timescale 1ns / 1ps

module Big_Boss (
    input  logic       sys_clk,
    input  logic       reset,
    input  logic       PS2Clk,
    input  logic       PS2Data,

    output logic [6:0] seg,
    output logic       dot,
    output logic [3:0] en,
    
    output logic [7:0] JC
);

logic [7:0] key_data;

keyboard_manager KEYBOARD (
    .sys_clk  (sys_clk),
    .reset    (reset),
    .PS2Clk   (PS2Clk),
    .PS2Data  (PS2Data),
    .key_data (key_data),
    .seg      (seg),
    .dot      (dot),
    .en       (en)
);

sine_generator SINE (
    .sys_clk  (sys_clk),
    .reset    (reset),
    .data_in  (key_data),
    .data_out (JC)
);

endmodule