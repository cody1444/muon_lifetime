module display_mux (
    input clk_1kHz,       // Slow clock for digit cycling
    output reg [7:0] anodes,   // 8-bit anode control (active LOW)
    output reg [2:0] current_digit // Current digit index
);

    initial current_digit = 0;

    always @(posedge clk_1kHz) begin
        current_digit <= current_digit + 1;
    end

    always @(*) begin
        anodes = ~(8'b00000001 << current_digit); // Activate only one display at a time (active LOW)
    end

endmodule
