module top_display (
    input clk,             // 100MHz System Clock
    input sw_left,         // Mode selection switch (tied to TDC)
    input sw_right,        // Mode selection switch (tied to coincidences)
    input [15:0] digits_A, // First counter output
    input [15:0] digits_B, // Second counter output
    input [15:0] digits_C, // Coincidence counter output
    input [15:0] digits_D, // TDC output
    output [6:0] segments, // 7-segment display output
    output [7:0] anodes    // 8-bit anode control
);

    // Display Mode Selector (Handles switching between modes)
    display_mode_selector display_selector (
        .clk(clk),
        .sw_left(sw_left),
        .sw_right(sw_right),
        .digits_A(digits_A),
        .digits_B(digits_B),
        .digits_C(digits_C),
        .digits_D(digits_D),
        .segments(segments),
        .anodes(anodes)
    );

endmodule
