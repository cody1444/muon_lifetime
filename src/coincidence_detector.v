module coincidence_detector (
    input clk,
    input button_A,  // Debounced button A
    input button_B,  // Debounced button B
    output wire coincidence_detected
);
    reg coincidence =0;

    rising_edge_detector coincidence_edge (
        .clk(clk),
        .signal_in(coincidence),
        .pulse_out(coincidence_detected)
    );

    always @(posedge clk) begin
        coincidence <= button_A & button_B; // Coincidence pulse when both are HIGH
    end

endmodule

