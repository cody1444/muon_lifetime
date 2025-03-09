`timescale 1ns / 1ps

module top_tb;
    reg clk;
    reg [1:0] buttons;   // Buttons: [0] = A, [1] = B
    reg sw_mode;         // Mode selection switch
    wire [6:0] segments; // 7-segment display output
    wire [7:0] anodes;   // 8-bit anode control

    // Instantiate the DUT (Device Under Test)
    top uut (
        .clk(clk),
        .buttons(buttons),
        .sw_mode(sw_mode),
        .segments(segments),
        .anodes(anodes)
    );

    // Generate 100MHz clock
    always #5 clk = ~clk; // 100MHz clock → Toggle every 5ns

    initial begin
        $display("Testing Top-Level Module (Button A Only)");
        //$monitor("Time=%0t | button_A=%b | digits_A=%d | segments=%b | anodes=%b", $time, buttons[0], uut.core.counter_A.digits, segments, anodes);

        // Enable waveform dump
        $dumpfile("sim/top_tb.vcd");
        $dumpvars(0, top_tb);

        // === Initialize Signals ===
        clk = 0;
        buttons = 3'b000;
        sw_mode = 0;

        // === CASE 1: Increment Button A ===
        #100;
        buttons[0] = 1; // Press Button A
        #100;
        buttons[0] = 0; // Release Button A
        #100;

        #100;
        buttons[0] = 1; // Press Button A Again
        #100;
        buttons[0] = 0; // Release Button A
        #100;

        #100;
        buttons[0] = 1; // Press Button A Again
        #100;
        buttons[0] = 0; // Release Button A
        #100;

        // Wait and observe display changes
        #500_000; 

        $display("Test Complete");
        $finish;
    end
endmodule

