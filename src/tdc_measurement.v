module tdc_measurement #(
    parameter TIMEOUT_CYCLES = 50_000_000  // Default timeout: 0.5s at 100MHz
)(
    input clk,           // System clock (100MHz)
    input coincidence,   // Coincidence detection signal (rising edge)
    input button_C,      // Debounced third button input
    output wire [15:0] time_measurement // Constrained to 16-bit for display
);

    reg [15:0] bin_time_measurement = 16'h0000;
    reg [31:0] counter = 0;  // Full 32-bit counter for precision
    reg measuring = 0;       // Tracks if measurement is active
    wire button_C_pulse;      // Pulse signal for button_C

    // Instantiate rising edge detector for button_C
    rising_edge_detector button_C_edge (
        .clk(clk),
        .signal_in(button_C),
        .pulse_out(button_C_pulse)
    );
    
    // Instantiate binary to BCD conversion, so time measurement can be
    // processed by display
    binary_to_bcd bcd_conversion (
        .binary(bin_time_measurement),
        .bcd(time_measurement)
    );


    always @(posedge clk) begin
        if (coincidence) begin
            measuring <= 1;  // Start measuring time when a coincidence occurs
            counter <= 0;
        end 
        
        if (measuring) begin
            if (button_C_pulse) begin
                bin_time_measurement <= counter[15:0];  // Store the **lower 16 bits**
                measuring <= 0;  // Stop measuring
            end 
            else if (counter >= TIMEOUT_CYCLES) begin
                bin_time_measurement <= TIMEOUT_CYCLES[15:0];  // **Max time stored on timeout**
                measuring <= 0;  // Stop measuring
            end 
            else begin
                counter <= counter + 1;  // Increment counter
            end
        end
    end

endmodule

