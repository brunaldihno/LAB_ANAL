module Big_Boss (
    input  logic        clk,
    input  logic        reset,
    input  logic        RX,
    input  logic        boton,

    output logic [6:0]  segments,
    output logic        punto,
    output logic [3:0]  enables
);

    // ============================================================
    // Señales internas
    // ============================================================

    // Clocks
    logic clk_UART;
    logic clk_LED;

    // UART_RX
    logic [7:0] uart_data;
    logic uart_ready;
    logic uart_active;

    // UART_receiver
    logic [15:0] receiver_data;
    logic receiver_waiting;

    // Procesador
    logic [15:0] processor_data_div;
    logic [15:0] processor_data_out;
    
    // Divisores
    logic [3:0] decena;
    logic [15:0] resto_decena;
    logic [3:0] unidad;
    logic [15:0] resto_unidad;
    logic [3:0] decima;
    logic [15:0] resto_decima;
    logic [3:0] centecima;
    logic [15:0] resto_centecima;
    logic [3:0] div_ready;


    // ============================================================
    // C - Clock divider
    // ============================================================

    clk_div #(
        .LIMIT(5208),
        .RESET_STATE(1'b0)
    ) C1 (
        .in_clk  (clk),
        .reset   (!uart_active),
        .out_clk (clk_UART)
    );
    
    clk_div #(
        .LIMIT(120000),
        .RESET_STATE(1'b0)
    ) C2 (
        .in_clk  (clk),
        .reset   (!receiver_waiting),
        .out_clk (timeout)
    );
    
    
    clk_div #(
        .LIMIT(50000),
        .RESET_STATE(1'b0)
    ) C3 (
        .in_clk  (clk),
        .reset   (reset),
        .out_clk (clk_LED)
    );


    // ============================================================
    // U - UART RX
    // ============================================================

    UART_RX U1 (
        .clk      (clk),
        .clk_UART (clk_UART),
        .RX       (RX),
        .reset    (reset),
        .data     (uart_data),
        .ready    (uart_ready),
        .active   (uart_active)
    );

    UART_receiver U2 (
        .clk      (clk),
        .reset    (reset),
        .timeout  (timeout),
        .new_data (uart_ready),
        .data_in  (uart_data),
        .data_out (receiver_data),
        .waiting  (receiver_waiting)
    );


    // ============================================================
    // P - Procesador
    // ============================================================

    procesor P1 (
        .in_clk      (clk),
        .reset       (reset),
        .boton       (boton),
        .div_ready   (div_ready),
        .data_in     (receiver_data),

        .decena      (decena),
        .unidad      (unidad),
        .decima      (decima),
        .centecima   (centecima),

        .data_div    (processor_data_div),
        .data_out    (processor_data_out)
    );


    // ============================================================
    // D - Divisores
    // ============================================================

    divisor #(
        .DIVISOR(10000)
    ) D1 (
        .clk       (clk),
        .reset     (reset),
        .data_in   (processor_data_div),
        .unidades  (decena),
        .resto     (resto_decena),
        .ready     (div_ready[0])
    );
   
    divisor #(
        .DIVISOR(1000)
    ) D2 (
        .clk       (clk),
        .reset     (reset),
        .data_in   (resto_decena),
        .unidades  (unidad),
        .resto     (resto_unidad),
        .ready     (div_ready[1])
    );
    
    divisor #(
        .DIVISOR(100)
    ) D3 (
        .clk       (clk),
        .reset     (reset),
        .data_in   (resto_unidad),
        .unidades  (decima),
        .resto     (resto_decima),
        .ready     (div_ready[2])
    );
    
        divisor #(
        .DIVISOR(10)
    ) D4 (
        .clk       (clk),
        .reset     (reset),
        .data_in   (resto_decima),
        .unidades  (centecima),
        .resto     (resto_centecima),
        .ready     (div_ready[3])
    );


    // ============================================================
    // L - LED driver
    // ============================================================

    LED_driver L1 (
        .clk      (clk),
        .clk_LED  (clk_LED),
        .reset    (reset),
        .data     (processor_data_out),
        .segments (segments),
        .punto    (punto),
        .enables  (enables)
    );

endmodule