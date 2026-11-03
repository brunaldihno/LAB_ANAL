`timescale 1ns / 1ps

module inc_LUT(
        input logic         sys_clk,
        input logic  [7:0]  data_in,
        output logic [3:0]  inc,
        output logic [15:0] frac
    );

always_ff @(posedge sys_clk) begin
    case (data_in)
        16'h0D: begin
            inc  <= 3'd1;
            frac <= 16'd25909;
        end
        16'h16: begin
            inc  <= 3'd1;
            frac <= 16'd31346;
        end
        16'h15: begin
            inc  <= 3'd1;
            frac <= 16'd37107;
        end
        16'h1E: begin
            inc  <= 3'd1;
            frac <= 16'd43211;
        end
        16'h1D: begin
            inc  <= 3'd1;
            frac <= 16'd49677;
        end
        16'h24: begin
            inc  <= 3'd1;
            frac <= 16'd56528;
        end
        16'h25: begin
            inc  <= 3'd1;
            frac <= 16'd63786;
        end
        16'h2D: begin
            inc  <= 3'd2;
            frac <= 16'd5940;
        end
        16'h2E: begin
            inc  <= 3'd2;
            frac <= 16'd14088;
        end
        16'h2C: begin
            inc  <= 3'd2;
            frac <= 16'd22719;
        end
        16'h36: begin
            inc  <= 3'd2;
            frac <= 16'd31864;
        end
        16'h35: begin
            inc  <= 3'd2;
            frac <= 16'd41553;
        end
        16'h3C: begin
            inc  <= 3'd2;
            frac <= 16'd51818;
        end
        16'h3E: begin
            inc  <= 3'd2;
            frac <= 16'd62693;
        end
        16'h43: begin
            inc  <= 3'd3;
            frac <= 16'd8679;
        end
        16'h46: begin
            inc  <= 3'd3;
            frac <= 16'd20886;
        end
        16'h44: begin
            inc  <= 3'd3;
            frac <= 16'd33818;
        end
        16'h4D: begin
            inc  <= 3'd3;
            frac <= 16'd47520;
        end
        16'h4E: begin
            inc  <= 3'd3;
            frac <= 16'd62037;
        end
        16'h54: begin
            inc  <= 3'd4;
            frac <= 16'd11881;
        end
        16'h55: begin
            inc  <= 3'd4;
            frac <= 16'd28175;
        end
        16'h56: begin
            inc  <= 3'd4;
            frac <= 16'd45438;
        end
        16'h5D: begin
            inc  <= 3'd4;
            frac <= 16'd63728;
        end
        16'h5A: begin
            inc  <= 3'd5;
            frac <= 16'd17569;
        end
        
        default: begin
            inc  <= 3'b0;
            frac <= 16'b0;
        end
    endcase
end
 
endmodule
