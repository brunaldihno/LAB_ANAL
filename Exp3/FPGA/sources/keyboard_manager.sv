module keyboard_manager (
    input  logic        sys_clk,
    input  logic        reset,
    input  logic        PS2Clk,
    input  logic        PS2Data,

    output logic [7:0]  key_data,
    output logic [6:0]  seg,
    output logic        dot,
    output logic [3:0]  en
);

    logic [8:0]     p2_data;
    logic [19:0]    led_data;
    
    rx_manager RM (
        .sys_clk  (sys_clk),
        .reset    (reset),
        .P2_clk   (PS2Clk),
        .P2_data  (PS2Data),
        .data_out (p2_data)
    );
    
    key_manager MNG(
        .sys_clk    (sys_clk),
        .reset      (reset),
        .data_in    (p2_data),
        .data_key   (key_data),
        .data_led   (led_data)
    );
   
   led_driver LED(
        .sys_clk    (sys_clk),
        .data       (led_data),
        .segments   (seg),
        .punto      (dot),
        .enables    (en)
   );
    
endmodule