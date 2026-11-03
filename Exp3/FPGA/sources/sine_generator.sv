`timescale 1ns / 1ps

module sine_generator(
    input logic         sys_clk,
    input logic         reset,
    input logic  [7:0]  data_in,
    output logic [7:0]  data_out
);

logic [3:0]  inc;
logic [15:0] frac;

logic [6:0] addres;
logic [6:0] next_addres;
int new_add;
logic [3:0] increment;

logic [7:0] sine_data;
logic invert;
logic up; 

logic tick;

typedef enum logic [2:0] {
        IDLE,
        CALC_A,
        CALC_B,
        CALC_C
    } state_t;

state_t state;

inc_LUT LUT(
    .sys_clk (sys_clk),
    .data_in (data_in),
    .inc (inc),
    .frac (frac)
);

phase_acumlator PHASE (
    .sys_clk    (sys_clk),
    .reset      (reset),
    .tick       (tick),
    .inc        (inc),
    .frac       (frac),
    .increment  (increment)
);

blk_mem_gen_0 ROM (
    .clka  (sys_clk),
    .addra (addres),
    .douta (sine_data)
);

clk_divider #() CLK(
    .sys_clk    (sys_clk),
    .reset      (reset),
    .incremento (2061584), // 48kHz
    .tick       (tick)
);

always_ff @(posedge sys_clk) begin
    if (reset) begin
        data_out    <= 8'd128;
        addres      <= 0;
        next_addres <= 0;
        up          <= 1;
        invert      <= 0;
        state       <= IDLE;
    end
    else begin
       if (tick) begin
            if (inc != 0) begin
                addres      <= next_addres;
                state       <= CALC_A;
            end
            else begin
                data_out    <= 8'd128;
                next_addres <= 0;
                addres      <= 0;
                up          <= 1;
                invert      <= 0;
                state       <= IDLE;
            end
       end
       else begin
            case (state)
                IDLE: begin
                    state <= IDLE;
                end
                
                CALC_A: begin
                    if (up)
                        new_add <= int'(addres) + int'(increment);
                    else
                        new_add <= int'(addres) - int'(increment);
                
                    state <= CALC_B;
                end
                
                CALC_B: begin
                    if (up) begin
                        if (new_add > 127) begin
                            next_addres <= 7'(255 - new_add);
                            up <= 0;
                        end
                        else begin
                            next_addres <= new_add[6:0];
                        end
                    end
                    else begin
                        if (new_add < 0) begin
                            next_addres <= 7'(-new_add - 1);
                            up <= 1;
                            invert <= ~invert;
                        end
                        else begin
                            next_addres <= new_add[6:0];
                        end
                    end
                
                    state <= CALC_C;
                end
                
                CALC_C: begin
                    if (invert)
                        data_out <= 255 - sine_data;
                    else
                        data_out <= sine_data;
                            
                    state <= IDLE;
                end
                
                default: begin
                    state <= IDLE;
                end
            endcase
       end
    end
end

endmodule