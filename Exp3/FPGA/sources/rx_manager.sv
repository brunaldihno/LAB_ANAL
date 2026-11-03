`timescale 1ns / 1ps

module rx_manager(
    input  logic       sys_clk,
    input  logic       reset,
    input  logic       P2_clk,
    input  logic       P2_data,
    output logic [8:0] data_out
);

logic PS2Clk_db;
logic PS2Data_db;

logic [7:0] p2_byte;
logic       p2_ready;

logic released;

debouncer DB1 (
    .sys_clk  (sys_clk),
    .reset    (reset),
    .data_in  (P2_clk),
    .data_out (PS2Clk_db)
);

debouncer DB2 (
    .sys_clk  (sys_clk),
    .reset    (reset),
    .data_in  (P2_data),
    .data_out (PS2Data_db)
);

p_rx PR (
    .sys_clk (sys_clk),
    .P2_clk  (PS2Clk_db),
    .P2_data (PS2Data_db),
    .reset   (reset),
    .data    (p2_byte),
    .ready   (p2_ready)
);

always_ff @(posedge sys_clk) begin
    if (reset) begin
        data_out  <= 9'b0;
        released  <= 0;
    end
    else begin
        if (p2_ready) begin
            if (p2_byte == 8'hF0)
                released <= 1;       
            else begin
                if (released)
                    data_out <= {1'b0, p2_byte};
                else
                    data_out <= {1'b1, p2_byte};

                released <= 0;
            end
        end
    end
end

endmodule
