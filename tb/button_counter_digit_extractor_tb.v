`timescale 1ns / 1ps

module button_counter_digit_extractor_tb;
    reg clk;
    reg reset;
    reg button;
    reg enable;
    wire [15:0] digits;
    wire [3:0] extracted_digit;
    reg [2:0] digit_index;  // Selecting which digit to extract

    // Instantiate the Button Counter (DUT)
    button_counter uut_counter (
        .clk(clk),
        .reset(reset),
        .button(button),
        .enable(enable),
        .digits(digits)
    );

    // Instantiate the Digit Extractor
    digit_extractor uut_extractor (
        .digits_A(digits),  // Use counter output as input
        .digits_B(16'h0000), // Not used in this test
        .digit_index(digit_index),
        .extracted_digit(extracted_digit)
    );

    // Generate a 100MHz clock (10ns period)
    always #5 clk = ~clk;

    initial begin
        $display("Testing Button Counter with Digit Extractor");
        $dumpfile("sim/button_counter_digit_extractor_tb.vcd"); // Save waveform
        $dumpvars(0, button_counter_digit_extractor_tb);

        clk = 0;
        reset = 1;
        button = 0;
        enable = 1;
        digit_index = 0;

        #50 reset = 0;  // Release reset after 50ns

        // Count up to 9
        repeat (9) begin
            #100 button = 1;
            #100 button = 0;
        end
        #200;

        // Count up to 19 (to verify tens place)
        repeat (10) begin
            #100 button = 1;
            #100 button = 0;
        end
        #200;

        // Count up to 199 (to verify hundreds place)
        repeat (180) begin
            #100 button = 1;
            #100 button = 0;
        end
        #200;

        // Count up to 1999 (to verify thousands place)
        repeat (1779) begin
            #100 button = 1;
            #100 button = 0;
        end
        #200;

        // Verify extraction at different positions
        digit_index = 0; #200;  // Extract ones place
        digit_index = 1; #200;  // Extract tens place
        digit_index = 2; #200;  // Extract hundreds place
        digit_index = 3; #200;  // Extract thousands place

        // Reset to check if counter clears correctly
        #500 reset = 1;
        #50 reset = 0;

        #500;  // Allow some time before stopping

        $display("Test Complete");
        $finish;
    end
endmodule

