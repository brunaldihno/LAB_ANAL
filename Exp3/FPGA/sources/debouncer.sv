`timescale 1ns / 1ps

module debouncer #(parameter int Muestras = 100) (
    input  logic    sys_clk,
    input  logic    reset,
    input  logic    data_in,
    output logic    data_out
);
    
    int count;
    logic state;
    
    always_ff @(posedge sys_clk) begin
        if (reset) begin
            count <= 0;
            state <= 0;
        end
        else begin
            if (data_in == ~state) begin
                count <= count + 1;
                if (count > Muestras) begin
                    state    <= data_in;
                    data_out <= data_in;
                end
            end
            else begin
                count <= 0;
            end
        end
    end
    
endmodule