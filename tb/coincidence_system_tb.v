`timescale 1ns / 1ps

module coincidence_system_tb;
    reg clk;
    reg button_A;
    reg button_B;
    wire coincidence_detected;
    wire enable_A;
    wire enable_B;
    
    // Instantiate the coincidence system
    coincidence_system #(
        .TOLERANCE_CYCLES(50),   // Adjusted for realistic test timing
        .SUSPEND_CYCLES(200)     // Reduced for simulation efficiency
    ) uut (
        .clk(clk),
        .button_A(button_A),
        .button_B(button_B),
        .coincidence_detected(coincidence_detected),
        .enable_A(enable_A),
        .enable_B(enable_B)
    );

    // Generate a clock signal (100MHz)
    always #5 clk = ~clk; // Toggle clock every 5ns (100MHz)

    initial begin
        $display("Testing Coincidence System");
        $monitor("Time=%0t | button_A=%b | button_B=%b | coincidence_detected=%b | enable_A=%b | enable_B=%b", 
                 $time, button_A, button_B, coincidence_detected, enable_A, enable_B);

        // Enable waveform dump
        $dumpfile("sim/coincidence_system_tb.vcd");
        $dumpvars(0, coincidence_system_tb);

        // Initialize signals
        clk = 0;
        button_A = 0;
        button_B = 0;

        // === CASE 1: Simultaneous Presses (Should trigger coincidence) ===
        #100;
        button_A = 1; button_B = 1;
        #100; // Hold for 100ns
        button_A = 0; button_B = 0;
        #200; // Wait for system response

        // === CASE 2: A Pressed First, Then B (Within Window, Should trigger) ===
        #100;
        button_A = 1;
        #50;  // Within tolerance window
        button_B = 1;
        #50
        button_A =0;
        #50; // Hold for 100ns
        button_B = 0;
        #200; // Wait for result

        // === CASE 3: B Pressed First, Then A (Within Window, Should trigger) ===
        #100;
        button_B = 1;
        #100; // Hold for 100ns
        button_B = 0;
        #50;  // Within tolerance window
        button_A = 1;
        #100; // Hold for 100ns
        button_A = 0;
        #200; // Wait for result

        // === CASE 4: Pressed Outside the Window (Should NOT trigger) ===
        #100;
        button_A = 1;
        #100; // Hold for 100ns
        button_A = 0;
        #500; // Beyond tolerance window
        button_B = 1;
        #100; // Hold for 100ns
        button_B = 0;
        #200; // No coincidence should be detected

        // === CASE 5: Verify Suspension (Should disable enable_A & enable_B) ===
        #100;
        button_A = 1; button_B = 1;
        #100; // Hold for 100ns
        button_A = 0; button_B = 0;
        #50;  // Suspension starts
        #500; // Wait during suspension (enable_A and enable_B should be 0)

        // === CASE 6: New Coincidence After Suspension (Should trigger normally) ===
        button_A = 1; button_B = 1;
        #100; // Hold for 100ns
        button_A = 0; button_B = 0;
        #200; // Coincidence should be detected again

        $display("Test Complete");
        $finish;
    end
endmodule
