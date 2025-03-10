module mode_select (
    input sw_left,   // Left switch
    input sw_right,  // Right switch
    output reg [1:0] mode  // Mode output (00, 01, 10, or 11)
);

    always @(*) begin
        case ({sw_left, sw_right})
            2'b00: mode = 2'b00;  // Default: Show digits_A & digits_B
            2'b01: mode = 2'b01;  // Show digits_C (Coincidence count)
            2'b10: mode = 2'b10;  // Show digits_D (TDC measurement)
            2'b11: mode = 2'b11;  // Blank display
            default: mode = 2'b00; // Fallback to default
        endcase
    end
endmodule
