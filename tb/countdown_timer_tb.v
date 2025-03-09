`timescale 1ns / 1ps

module countdown_timer_tb;
    reg clk;
    reg start;
    reg reset;
    wire done;

    // Instantiate the countdown timer
    countdown_timer #(.COUNTDOWN_CYCLES(5000)) uut (
        .clk(clk),
        .start(start),
        .reset(reset),
        .done(done)
    );

    // Generate a clock signal (100MHz)
    always #5 clk = ~clk; // Toggle clock every 5ns (100MHz)

    initial begin
        $display("Testing Countdown Timer");
        $monitor("Time=%0t | start=%b | reset=%b | done=%b", 
                 $time, start, reset, done);

        // Enable waveform dump
        $dumpfile("sim/countdown_timer_tb.vcd");
        $dumpvars(0, countdown_timer_tb);

        // Initialize signals
        clk = 0;
        start = 0;
        reset = 0;

        // Case 1: Normal operation, done should start LOW
        #100;

        // Case 2: Trigger countdown, done should go HIGH after COUNTDOWN_CYCLES
        start = 1;
        #10;
        start = 0; // Remove start signal after a short pulse

        // Wait for COUNTDOWN_CYCLES to complete
        #100_000;

        // Case 3: Check that 'done' goes HIGH after COUNTDOWN_CYCLES
        #100;

        // Case 4: Restart the timer and verify it resets correctly
        start = 1;
        #10;
        start = 0;
        #100_000;

        // Case 5: Test Reset - Reset the timer in the middle of countdown
        start = 1;
        #10;
        start = 0;
        #25_000;  // Wait halfway through the countdown
        reset = 1; // Apply reset
        #10;
        reset = 0; // Remove reset

        // Case 6: Start a new countdown after reset
        start = 1;
        #10;
        start = 0;
        #100_000;

        $display("Test Complete");
        $finish;
    end
endmodule

