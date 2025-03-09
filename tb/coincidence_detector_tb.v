`timescale 1ns / 1ps

module coincidence_detector_tb;
    reg clk;
    reg button_A;
    reg button_B;
    wire coincidence_detected;
    
    // Instantiate the coincidence detector
    coincidence_detector #(.TOLERANCE_CYCLES(5000)) uut (
        .clk(clk),
        .button_A(button_A),
        .button_B(button_B),
        .coincidence_detected(coincidence_detected)
    );

    // Generate a clock signal (100MHz)
    always #5 clk = ~clk; // Toggle clock every 5ns (100MHz)

    initial begin
        $display("Testing Coincidence Detector (Valid Coincidences Only)");
        $monitor("Time=%0t | button_A=%b | button_B=%b | coincidence_detected=%b", 
                 $time, button_A, button_B, coincidence_detected);

        // Enable waveform dump
        $dumpfile("sim/coincidence_detector_tb.vcd");
        $dumpvars(0, coincidence_detector_tb);

        // Initialize signals
        clk = 0;
        button_A = 0;
        button_B = 0;

        // === CASE 1: Simultaneous Presses (Should detect) ===
        #100;
        button_A = 1; button_B = 1;
        #10;
        button_A = 0; button_B = 0;
        #100; // Wait for result

        // === CASE 2: A Pressed First, Then B (Should detect) ===
        #100;
        button_A = 1;
        #10;
        button_A = 0;
        #10;
        button_B = 1;
        #10;
        button_B = 0;
        #100; // Wait for result

        // === CASE 3: B Pressed First, Then A (Should detect) ===
        #100;
        button_B = 1;
        #10;
        button_B = 0;
        #10;
        button_A = 1;
        #10;
        button_A = 0;
        #100; // Wait for result

        // === CASE 4: Pressed Outside the Window (Should NOT detect) ===
        #100;
        button_A = 1;
        #10;
        button_A = 0;
        #100_000; // Wait for tolerance window to expire
        button_B = 1;
        #10;
        button_B = 0;
        #100; // No coincidence should be detected

        $display("Test Complete");
        $finish;
    end
endmodule

