module coincidence_system #(
    parameter SUSPEND_CYCLES = 660
)(
    input clk,           // System clock (100MHz)
    input button_A,      // Debounced button A input
    input button_B,      // Debounced button B input
    output wire coincidence_detected, // One-cycle pulse when coincidence occurs
    output wire enable_A, // Enable signal for counter A
    output wire enable_B  // Enable signal for counter B
);

    // Coincidence Detector (detects valid coincidence events)
    coincidence_detector coincidence_inst (
        .clk(clk),
        .button_A(button_A),
        .button_B(button_B),
        .coincidence_detected(coincidence_detected)
    );

    // Suspension Control (prevents rapid coincidences)
    suspension_control #(.SUSPEND_CYCLES(SUSPEND_CYCLES)
    ) suspension_inst (
        .clk(clk),
        .coincidence_detected(coincidence_detected),
        .enable_A_out(enable_A),
        .enable_B_out(enable_B)
    );

endmodule

