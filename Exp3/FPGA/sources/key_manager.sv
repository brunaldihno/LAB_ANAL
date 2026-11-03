`timescale 1ns / 1ps

module key_manager (
    input  logic        sys_clk,
    input  logic        reset,
    input  logic [8:0]  data_in,
    output logic [7:0]  data_key,
    output logic [19:0] data_led
);

logic [7:0] prev_key;

always_ff @(posedge sys_clk) begin
    if (reset) begin
        data_led    <= 20'b0;
        data_key    <= 8'b0;
        prev_key    <= 8'b0;
    end
    else begin
        data_led <= {7'b0, data_in[8], 4'b0 , data_in[7:0]};
        if (data_in[8]) begin
            data_key    <= data_in[7:0];
            prev_key    <= data_in[7:0];
        end 
        else if (data_in[7:0] == prev_key) 
            data_key    <= 8'b0;
    end
end

endmodule