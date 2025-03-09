module top_display (
    input clk,             // 100MHz System Clock
    input sw_mode,         // Mode selection switch
    input [15:0] digits_A, // First counter output
    input [15:0] digits_B, // Second counter output
    input [15:0] digits_C, // Coincidence counter output
    output [6:0] segments, // 7-segment display output
    output [7:0] anodes    // 8-bit anode control
);

    // Display Mode Selector (Handles switching between modes)
    display_mode_selector display_selector (
        .clk(clk),
        .sw_mode(sw_mode),
        .digits_A(digits_A),
        .digits_B(digits_B),
        .digits_C(digits_C),
        .segments(segments),
        .anodes(anodes)
    );

endmodule
