module top (
    input clk,             // 100MHz System Clock
    input [2:0] buttons,   // Buttons (A, B, C)
    input sw_left,         // Mode Selection Switch (tied to TDC)
    input sw_right,        // Mode Selection Switch (tied to coincidences)
    output [6:0] segments, // 7-segment display output
    output [7:0] anodes    // 8-bit anode control
);

    wire [15:0] digits_A, digits_B, digits_C; // Counter outputs
    wire [15:0] digits_D; // TDC output

    // Core Logic (Debounce, Counters, Coincidence)
    top_core core_inst (
        .clk(clk),
        .buttons(buttons),
        .digits_A(digits_A),
        .digits_B(digits_B),
        .digits_C(digits_C),
        .digits_D(digits_D)
    );

    // Display System (Multiplexed Display)
    top_display display_inst (
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

