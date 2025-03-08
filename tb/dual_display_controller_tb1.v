`timescale 1ns / 1ps

module dual_display_controller_tb1;
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

    // Generate a 100MHz clock (10ns period)
    always #5 clk = ~clk; // Toggle every 5ns (100MHz)

    initial begin
        $display("Testing Dual Display Controller");
        $dumpfile("sim/dual_display_controller_tb1.vcd"); // Save waveform
        $dumpvars(0, dual_display_controller_tb1);

        clk = 0;
        digits_A = 16'h0000; // Start at 0000
        digits_B = 16'h9999; // Start at 9999

        // simulate human button presses incrementing every 200 ms
        repeat (10) begin
            #200000000; // Wait 200ms
            digits_A = digits_A + 16'h0001; // Increment A
            digits_B = digits_B - 16'h0001; // Decrement B
            $display("Time=%0t | digits_A=%h | digits_B=%h", $time, digits_A, digits_B);
        end

        #200000000; // Run an additional 200ms for stability

        $display("Test Complete");
        $finish;
    end
endmodule

