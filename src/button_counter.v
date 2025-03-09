module button_counter (
    input clk,        // System clock (100MHz)
    input reset,      // Reset signal
    input button,     // Debounced button signal (1-bit)
    input enable,     // Enable signal (1 = counter active, 0 = counter disabled)
    output reg [15:0] digits = 16'h0000 // 4-digit counter (BCD)
);

    reg button_state = 0, button_prev = 0;  // Track button state

    always @(posedge clk) begin
        if (reset) begin
            digits <= 16'h0000;  // Reset counter
            button_prev <= 0;
            button_state <= 0;
        end else if (enable) begin
            button_prev <= button_state;
            button_state <= button;

            // Detect rising edge (button goes from 0 -> 1)
            if (button_prev == 0 && button_state == 1) begin
                // Proper BCD counting logic
                if (digits[3:0] < 4'd9) begin
                    digits[3:0] <= digits[3:0] + 1; // Increment ones place
                end else begin
                    digits[3:0] <= 4'd0; // Reset ones place
                    if (digits[7:4] < 4'd9) begin
                        digits[7:4] <= digits[7:4] + 1; // Increment tens place
                    end else begin
                        digits[7:4] <= 4'd0; // Reset tens place
                        if (digits[11:8] < 4'd9) begin
                            digits[11:8] <= digits[11:8] + 1; // Increment hundreds place
                        end else begin
                            digits[11:8] <= 4'd0; // Reset hundreds place
                            if (digits[15:12] < 4'd9) begin
                                digits[15:12] <= digits[15:12] + 1; // Increment thousands place
                            end else begin
                                digits[15:12] <= 4'd0; // Reset thousands place (rollover)
                            end
                        end
                    end
                end
            end
        end
    end

endmodule

