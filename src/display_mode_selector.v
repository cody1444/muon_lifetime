module display_mode_selector (
    input clk,
    input sw_left,   // Switch to select display mode
    input sw_right,   // Switch to select display mode
    input [15:0] digits_A,  // First 4-digit count (Mode 0)
    input [15:0] digits_B,  // Second 4-digit count (Mode 0)
    input [15:0] digits_C,  // Coincidences 4-digit count (Mode 1)
    input [15:0] digits_D,  // TDC 4-digit (Mode 2)
    output [6:0] segments,  // 7-segment output (shared)
    output [7:0] anodes     // 8-bit anode control (active LOW)
);

    wire [1:0] mode;  // Mode signal from mode_select module
    wire [6:0] segments_mode_0, segments_mode_1, segments_mode_2;
    wire [7:0] anodes_mode_0, anodes_mode_1, anodes_mode_2;

    // Mode selection module (directly reads switch)
    mode_select mode_ctrl (
        .sw_left(sw_left),
        .sw_right(sw_right),
        .mode(mode)
    );

    // Mode multiplexer (separate module)
    mode_mux mode_select_mux (
        .mode(mode),
        .segments_mode_0(segments_mode_0),
        .segments_mode_1(segments_mode_1),
        .segments_mode_2(segments_mode_2),
        .anodes_mode_0(anodes_mode_0),
        .anodes_mode_1(anodes_mode_1),
        .anodes_mode_2(anodes_mode_2),
        .segments(segments),
        .anodes(anodes)
    );

    // Full dual-display controller (Mode 0) - digits_A and digits_B are used
    dual_display_controller counter_display (
        .clk(clk),
        .digits_A(digits_A),
        .digits_B(digits_B),
        .segments(segments_mode_0),
        .anodes(anodes_mode_0)
    );

    // Single display controller (Mode 1) - digits_C is used, leftmost displays off
    dual_display_controller coincidences_display (
        .clk(clk),
        .digits_A(digits_C),   // Show digits_C in mode 1
        .digits_B(16'hFFFF),   // Turn off leftmost displays
        .segments(segments_mode_1),
        .anodes(anodes_mode_1)
    );

    // Single display controller (Mode 2) - digits_D is used, leftmost displays off
    dual_display_controller tdc_display (
        .clk(clk),
        .digits_A(digits_D),   // Show digits_D in mode 1
        .digits_B(16'hFFFF),   // Turn off leftmost displays
        .segments(segments_mode_2),
        .anodes(anodes_mode_2)
    );
endmodule
