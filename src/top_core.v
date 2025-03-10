module top_core (
    input clk,            // 100MHz System Clock
    input [2:0] buttons,  // Three input buttons (A, B, C)
    output [15:0] digits_A, // First counter output
    output [15:0] digits_B, // Second counter output
    output [15:0] digits_C, // Coincidence counter output
    output [15:0] digits_D  // TDC information
);
    
    wire [4:0] debounced_buttons;  // Debounced buttons
    wire coincidence_detected;     // Coincidence detection pulse
    wire enable_A, enable_B;       // Counter enable signals

    // Debounce all button inputs
    debounce debounce_inst (
        .clock(clk),
        .reset(1'b0),
        .enable(1'b0),
        .button({2'b00, buttons}),
        .out(debounced_buttons)
    );

    // Coincidence System (Detects coincidences & controls counting)
    coincidence_system coincidence_inst (
        .clk(clk),
        .button_A(debounced_buttons[0]),
        .button_B(debounced_buttons[1]),
        .coincidence_detected(coincidence_detected),
        .enable_A(enable_A),
        .enable_B(enable_B)
    );

    // Button Counter for A
    button_counter counter_A (
        .clk(clk),
        .reset(1'b0),
        .button(debounced_buttons[0]),
        .enable(enable_A),
        .digits(digits_A)
    );

    // Button Counter for B
    button_counter counter_B (
        .clk(clk),
        .button(debounced_buttons[1]),
        .enable(enable_B),
        .digits(digits_B)
    );

    // Button Counter for Coincidence Count
    button_counter counter_C (
        .clk(clk),
        .button(coincidence_detected), // Increment when a coincidence is detected
        .enable(1'b1),                 // Always enabled
        .digits(digits_C)
    );

    tdc_measurement #(.TIMEOUT_CYCLES(660)) tdc (
        .clk(clk),
        .coincidence(coincidence_detected),
        .button_C(debounced_buttons[2]),
        .time_measurement(digits_D)
    );

endmodule

