module suspension_control #(
    parameter SUSPEND_CYCLES = 500_000_000 // Default 5s suspension at 100MHz
)(
    input clk,                   // System clock (100MHz)
    input coincidence_detected,   // Coincidence detection signal
    output reg enable_A_out,      // Enable signal for counter A
    output reg enable_B_out       // Enable signal for counter B
);

    reg [31:0] suspend_counter = 0; // 32-bit counter for long suspensions
    reg suspend = 0;

    always @(posedge clk) begin
        if (coincidence_detected && !suspend) begin
            suspend <= 1;  // Start suspension
            suspend_counter <= SUSPEND_CYCLES; // Set suspension time
        end

        if (suspend) begin
            enable_A_out <= 0; // Disable counting
            enable_B_out <= 0; // Disable counting
            if (suspend_counter > 0) begin
                suspend_counter <= suspend_counter - 1;
            end else begin
                suspend <= 0;
                enable_A_out <= 1; // Re-enable counting
                enable_B_out <= 1; // Re-enable counting
            end
        end else begin
            enable_A_out <= 1;
            enable_B_out <= 1;
        end
    end

endmodule
