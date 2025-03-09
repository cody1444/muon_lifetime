`timescale 1ns / 1ps

module display_mode_selector_tb;
    reg clk;
    reg sw_mode;  // Switch for mode selection
    reg [15:0] digits_A;
    reg [15:0] digits_B;
    reg [15:0] digits_C;
    wire [6:0] segments;
    wire [7:0] anodes;

    // Instantiate the Device Under Test (DUT)
    display_mode_selector uut (
        .clk(clk),
        .sw_mode(sw_mode),
        .digits_A(digits_A),
        .digits_B(digits_B),
        .digits_C(digits_C),
        .segments(segments),
        .anodes(anodes)
    );

    // Generate a 100MHz clock (10ns period)
    always #5 clk = ~clk;

    initial begin
        $display("Testing Mode Switching");
        $dumpfile("sim/display_mode_selector_tb.vcd"); // Waveform output
        $dumpvars(0, display_mode_selector_tb);

        clk = 0;
        digits_A = 16'h1234; // Example values
        digits_B = 16'h5678;
        digits_C = 16'h9876;

        // Start in Mode 0 (Dual Display)
        sw_mode = 0;
        #16_000_000;  // Run for some time
        
        // Switch to Mode 1 (Single Number)
        sw_mode = 1;
        #16_000_000;

        // Switch back to Mode 0
        sw_mode = 0;
        #16_000_000;

        $display("Test Complete");
        $finish;
    end
endmodule
