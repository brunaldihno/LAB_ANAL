`timescale 1ns / 1ps

module phase_acumlator(
    input logic         sys_clk,
    input logic         reset,
    input logic         tick,
    input logic  [3:0]  inc,
    input logic  [15:0] frac,
    output logic [3:0]  increment
);
    
logic [16:0] phase;
logic [16:0] prev_phase;
    
always_ff @(posedge sys_clk) begin
    if (reset) begin
        increment     <= 0;
        phase   <= 0;
    end
    else begin
        if (tick) begin
            prev_phase  <= phase;
            phase       <= phase + frac;
        end
        else begin
            if (prev_phase[16] == ~phase[16])
                increment <= inc + 1;
            else begin
                increment <= inc;
            end
        end
    end
end    
     
endmodule
