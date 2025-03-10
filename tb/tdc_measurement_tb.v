`timescale 1ns / 1ps

module tdc_measurement_tb;
    reg clk;
    reg coincidence;
    reg button_C;
    wire [15:0] time_measurement;

    // Instantiate the TDC Measurement module
    tdc_measurement #(
        .TIMEOUT_CYCLES(150) // Shorter timeout for faster simulation
    ) uut (
        .clk(clk),
        .coincidence(coincidence),
        .button_C(button_C),
        .time_measurement(time_measurement)
    );

    // Generate a clock signal (100MHz)
    always #5 clk = ~clk; // Toggle clock every 5ns (100MHz)

    initial begin
        $display("Testing TDC Measurement");
        $monitor("Time=%0t | coincidence=%b | button_C=%b | time_measurement=%d", 
                 $time, coincidence, button_C, time_measurement);

        // Enable waveform dump
        $dumpfile("sim/tdc_measurement_tb.vcd");
        $dumpvars(0, tdc_measurement_tb);

        // Initialize signals
        clk = 0;
        coincidence = 0;
        button_C = 0;

        // === CASE 1: Normal Measurement ===
        #50;
        coincidence = 1;  // Coincidence occurs
        #10;
        coincidence = 0;  // Clear signal
        #200;  // Simulated delay
        button_C = 1;  // Press button_C
        #10;
        button_C = 0;
        #100;

        // === CASE 2: Timeout Occurs ===
        #500;
        coincidence = 1;  // Coincidence occurs
        #10;
        coincidence = 0;  // Clear signal
        #1500;  // Wait beyond timeout, button_C never pressed

        // === CASE 3: Late Button Press (Ignored) ===
        #500;
        coincidence = 1;  // Coincidence occurs
        #10;
        coincidence = 0;  // Clear signal
        #1100;  // Timeout occurs first
        button_C = 1;  // Too late!
        #10;
        button_C = 0;
        #100;

        $display("Test Complete");
        $finish;
    end
endmodule

