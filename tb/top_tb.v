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
        $display("Starting Comprehensive Test (50 Presses, 25 Coincidences)");
        $monitor("Time=%0t | button_A=%b | button_B=%b | digits_A=%d | digits_B=%d | digits_C=%d | mode=%b | segments=%b | anodes=%b", $time, buttons[0], buttons[1], uut.core_inst.counter_A.digits, uut.core_inst.counter_B.digits, uut.core_inst.counter_C.digits, sw_mode, segments, anodes);

        // Enable waveform dump
        $dumpfile("sim/top_tb.vcd");
        $dumpvars(0, top_tb);

        // === Initialize Signals ===
        clk = 0;
        buttons = 2'b00;
        sw_mode = 0;  // Start in Mode 0

        // === CASE 1: 50 Button Presses ===
        repeat (50) begin
            #500;
            if ($time % 500 == 0) begin
                buttons[0] = 1; buttons[1] = 1; // Every 5th press, trigger coincidence
            end
            else if ($time % 200 == 0) begin
                buttons[0] = 1; // Otherwise, press A
            end
            else begin
                buttons[1] = 1; // Press B end
            end
            #150; // Controls duration of press
            buttons[0] = 0; buttons[1] = 0; // Release buttons
        end

        // === CASE 2: Check Mode 0 (0025 0025) ===
        #500;
        sw_mode = 0;
        #100_000;

        // === CASE 3: Check Mode 1 (0005) ===
        #500;
        sw_mode = 1;
        #100_000; 

        $display("Comprehensive Test Complete");
        $finish;
    end
endmodule
