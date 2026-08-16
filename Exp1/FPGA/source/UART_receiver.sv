`timescale 1ns / 1ps

module UART_receiver (
    input  logic        clk,
    input  logic        reset,
    input  logic        over,
    input  logic        new_data,
    input  logic [7:0]  data_in,
    output logic [15:0] data_out,
    output logic        waiting
);

    logic [7:0] buffer;

    always_ff @(posedge clk) begin

        if (reset) begin
            buffer  <= 8'b0;
            data_out <= 16'b0;
            waiting <= 1'b0;
        end
        
        else if (over) begin
            buffer  <= 8'b0;
            waiting <= 1'b0;
        end
        
        else if (!waiting) begin

            if (new_data) begin
                buffer  <= data_in;
                waiting <= 1'b1;
            end
        
        end
        
        else begin

            if (new_data) begin
                data_out <= {buffer, data_in};
                buffer   <= 8'b0;
                waiting  <= 1'b0;
            end

        end

    end

endmodule