module rising_edge_detector (
    input clk,
    input signal_in,
    output reg pulse_out
);

    reg signal_prev = 0;

    always @(posedge clk) begin
        pulse_out <= (signal_in && !signal_prev); // Detect LOW → HIGH transition
        signal_prev <= signal_in; // Store previous state
    end

endmodule

