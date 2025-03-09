module top (
    input clk,             // 100MHz System Clock
    input [1:0] buttons,   // Buttons (A, B)
    input sw_mode,         // Mode Selection Switch
    output [6:0] segments, // 7-segment display output
    output [7:0] anodes    // 8-bit anode control
);

    wire [15:0] digits_A, digits_B, digits_C; // Counter outputs

    // Core Logic (Debounce, Counters, Coincidence)
    top_core core_inst (
        .clk(clk),
        .buttons(buttons),
        .digits_A(digits_A),
        .digits_B(digits_B),
        .digits_C(digits_C)
    );

    // Display System (Multiplexed Display)
    top_display display_inst (
        .clk(clk),
        .sw_mode(sw_mode),
        .digits_A(digits_A),
        .digits_B(digits_B),
        .digits_C(digits_C),
        .segments(segments),
        .anodes(anodes)
    );

endmodule

