`timescale 1ns / 1ps

module seven_segment_decoder_tb;
    reg [3:0] digit;       // 4-bit input to test all possible values
    wire [6:0] segments;   // 7-bit output from DUT

    // Instantiate the Device Under Test (DUT)
    seven_segment_decoder uut (
        .digit(digit),
        .segments(segments)
    );

    initial begin
        $display("Testing Seven Segment Decoder");
        $monitor("Time=%0t | digit=%b (%d) -> segments=%b", $time, digit, digit, segments);

        // Enable waveform dump
        $dumpfile("../sim/seven_segment_decoder_tb.vcd"); // Save VCD in sim/ folder
        $dumpvars(0, seven_segment_decoder_tb);

        // Test all possible values for digit (0-15)
        for (digit = 0; digit < 16; digit = digit + 1) begin
            #10; // Wait 10 time units
        end

        $display("Test Complete");
        $finish;
    end
endmodule
