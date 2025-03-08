module dual_display_controller (
    input clk,
    input [15:0] digits_A,  // First 4 digits (right number)
    input [15:0] digits_B,  // Second 4 digits (left number)
    output [6:0] segments,  // 7-segment output (shared)
    output [7:0] anodes    // 8-bit anode control (active LOW)
);

    wire [3:0] extracted_digit;
    wire [2:0] current_digit; // 3-bit counter for 8 digits
    wire clk_1kHz;

    // Instantiate slow clock, enables cycling through 8 displays
    slow_clock slow_clk_inst (
        .clk(clk),
        .clk_1kHz(clk_1kHz)
    );

    // Cycle through the eight displays, holding respective anode low
    display_mux disp_mux_inst (
        .clk_1kHz(clk_1kHz),
        .anodes(anodes),
        .current_digit(current_digit)
    );

    // Extract digit (thousands, hundreds, tens, ones) from input
    digit_extractor digit_extract_inst (
        .digits_A(digits_A),
        .digits_B(digits_B),
        .digit_index(current_digit),
        .extracted_digit(extracted_digit)
    );

    // Instantiate seven_segment_decoder
    seven_segment_decoder decoder_inst (
        .digit(extracted_digit),
        .segments(segments)
    );

endmodule

