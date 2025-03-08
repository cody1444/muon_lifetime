`timescale 1ns / 1ps

module dual_display_controller_tb;
    reg clk;
    reg [15:0] digits_A;  // First 4 digits
    reg [15:0] digits_B;  // Second 4 digits
    wire [6:0] segments;  // 7-segment output (shared)
    wire [7:0] anodes;    // 8-bit anode control (active LOW)

    // Instantiate the Device Under Test (DUT)
    dual_display_controller uut (
        .clk(clk),
        .digits_A(digits_A),
        .digits_B(digits_B),
        .segments(segments),
        .anodes(anodes)
    );

    // Generate a 100MHz clock (period = 10ns)
    always #5 clk = ~clk; // Toggle every 5ns (100MHz)

    initial begin
        $display("Testing Dual Display Controller");
        $dumpfile("sim/dual_display_controller_tb.vcd"); // Save waveform
        $dumpvars(0, dual_display_controller_tb);

        clk = 0;

        // Test case: 7115 in digits_A, 4937 in digits_B
        digits_A = 16'h7115; // BCD representation of "7115"
        digits_B = 16'h4937; // BCD representation of "4937"

        // Run for 20ms (to allow multiple digit cycles)
        #20000000; 

        $display("Test Complete");
        $finish;
    end
endmodule

