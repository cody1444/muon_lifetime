`timescale 1ns / 1ps

module top_tb;
    reg clk;
    reg [2:0] buttons;   // Buttons: [0] = A, [1] = B, [2] = C
    reg sw_left;         // Mode selection switch (coincidence mode)
    reg sw_right;        // Mode selection switch (TDC mode)
    wire [6:0] segments; // 7-segment display output
    wire [7:0] anodes;   // 8-bit anode control

    // Instantiate the DUT (Device Under Test)
    top uut (
        .clk(clk),
        .buttons(buttons),
        .sw_left(sw_left),
        .sw_right(sw_right),
        .segments(segments),
        .anodes(anodes)
    );

    // Generate 100MHz clock
    always #5 clk = ~clk; // 100MHz clock → Toggle every 5ns

    initial begin
        $display("Starting Comprehensive Test (Button Presses, Coincidences, and TDC Timing)");
        $monitor("Time=%0t | A=%b | B=%b | C=%b | digits_A=%d | digits_B=%d | digits_C=%d | digits_D=%d | mode_L=%b | mode_R=%b | segments=%b | anodes=%b", 
                 $time, buttons[0], buttons[1], buttons[2], uut.core_inst.counter_A.digits, uut.core_inst.counter_B.digits, uut.core_inst.counter_C.digits, uut.core_inst.tdc.time_measurement, sw_left, sw_right, segments, anodes);

        // Enable waveform dump
        $dumpfile("sim/top_tb.vcd");
        $dumpvars(0, top_tb);

        // === Initialize Signals ===
        clk = 0;
        buttons = 3'b000;
        sw_left = 0;  
        sw_right = 0;

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
            #25; // Controls duration of press
            buttons[0] = 0; buttons[1] = 0; // Release buttons
        end

        // === CASE 2: Check Mode 0 (0025 0025) ===
        #500;
        sw_left = 0;
        sw_right = 0;
        #100_000;

        // === CASE 3: Check Mode 1 (Coincidences - should show 0005) ===
        #500;
        sw_left = 0;
        sw_right = 1;
        #100_000; 

        // === CASE 4: Check Mode 2 (TDC Mode - should show last TDC measurement) ===
        #500;
        sw_left = 1;
        sw_right = 0;
        #100_000;

        // === CASE 5: Check Mode 3 (Blank Display) ===
        #500;
        sw_left = 1;
        sw_right = 1;
        #100_000;

        // === CASE 6: Coincidence & Fast C Press (Valid TDC Measurement) ===
        #500;
        sw_left = 1; // Set dipslay to TDC mode
        sw_right = 0;
        buttons[0] = 1; buttons[1] = 1; // Trigger coincidence
        #25;
        buttons[0] = 0; buttons[1] = 0;
        #2200;   // Short delay
        buttons[2] = 1; // Press Button C
        #25;
        buttons[2] = 0; // Release Button C
        #100_000; // Allow TDC value to register

        // === CASE 7: Coincidence but No C Press (Timeout) ===
        #500;
        buttons[0] = 1; buttons[1] = 1; // Trigger coincidence
        #25;
        buttons[0] = 0; buttons[1] = 0;
        #10_000; // Exceed timeout (digits_D should show max value)
        
        // === CASE 8: Coincidence & C Press at Edge of Timeout ===
        #500;
        buttons[0] = 1; buttons[1] = 1; // Trigger coincidence
        #25;
        buttons[0] = 0; buttons[1] = 0;
        #5500; // Just before timeout
        buttons[2] = 1; // Press Button C
        #25;
        buttons[2] = 0; // Release Button C
        #100_000; // Allow TDC value to register

        $display("Comprehensive Test Complete");
        $finish;
    end
endmodule

