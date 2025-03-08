`timescale 1ns / 1ps

module digit_extractor_tb;
    reg [15:0] digits_A;
    reg [15:0] digits_B;
    reg [2:0] digit_index;
    wire [3:0] extracted_digit;

    // Instantiate the Device Under Test (DUT)
    digit_extractor dut (
        .digits_A(digits_A),
        .digits_B(digits_B),
        .digit_index(digit_index),
        .extracted_digit(extracted_digit)
    );

    initial begin
        $display("Testing Digit Extractor");
        $dumpfile("sim/digit_extractor_tb.vcd"); // Enable waveform dump
        $dumpvars(0, digit_extractor_tb);

        // Test case 1: 7115 in digits_A, 4937 in digits_B
        digits_A = 16'h7115; // BCD for "7115"
        digits_B = 16'h4937; // BCD for "4937"

        // Iterate over all 8 digits
        for (digit_index = 0; digit_index < 8; digit_index = digit_index + 1) begin
            #10; // Wait 10 time units
            $display("digit_index=%d | extracted_digit=%b (decimal %d)", 
                     digit_index, extracted_digit, extracted_digit);
        end

        $display("Test Complete");
        $finish;
    end
endmodule

