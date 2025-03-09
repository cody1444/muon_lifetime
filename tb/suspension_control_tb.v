`timescale 1ns / 1ps

module suspension_control_tb;
    reg clk;
    reg coincidence_detected;
    wire enable_A_out;
    wire enable_B_out;

    // Instantiate the suspension control module
    suspension_control #(.SUSPEND_CYCLES(50_000)) uut (
        .clk(clk),
        .coincidence_detected(coincidence_detected),
        .enable_A_out(enable_A_out),
        .enable_B_out(enable_B_out)
    );

    // Generate a clock signal (100MHz)
    always #5 clk = ~clk; // Toggle clock every 5ns (100MHz)

    initial begin
        $display("Testing Suspension Control");
        $monitor("Time=%0t | coincidence_detected=%b | enable_A_out=%b | enable_B_out=%b",
                 $time, coincidence_detected, enable_A_out, enable_B_out);

        // Enable waveform dump
        $dumpfile("sim/suspension_control_tb.vcd");
        $dumpvars(0, suspension_control_tb);

        // Initialize signals
        clk = 0;
        coincidence_detected = 0;

        // Normal operation: enable_A and enable_B should be HIGH
        #100;
        
        // Trigger coincidence event (suspension starts)
        coincidence_detected = 1;
        #10; // Give time for suspension logic to react
        coincidence_detected = 0; // Reset signal

        // Wait for suspension period to complete (1ms)
        #1_000_000;

        // Check if enable_A and enable_B return HIGH
        #100;

        $display("Test Complete");
        $finish;
    end
endmodule

