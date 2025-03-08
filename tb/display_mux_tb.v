`timescale 1ns / 1ps

module display_mux_tb;
    reg clk_1kHz;
    wire [7:0] anodes;
    wire [2:0] current_digit;

    // Instantiate the Device Under Test (DUT)
    display_mux dut (
        .clk_1kHz(clk_1kHz),
        .anodes(anodes),
        .current_digit(current_digit)
    );

    // Generate a 1kHz clock (Period = 1ms, Toggle every 0.5ms)
    always #500000 clk_1kHz = ~clk_1kHz; // 500,000 time units = 0.5ms

    initial begin
        $display("Testing Display Multiplexer");
        $dumpfile("sim/display_mux_tb.vcd"); // Save waveform
        $dumpvars(0, display_mux_tb);

        clk_1kHz = 0;
        seg_in = 7'b1010101; // Random test pattern for segments

        // Run the test for 10ms (should cycle through all digits multiple times)
        #10000000;

        $display("Test Complete");
        $finish;
    end
endmodule

