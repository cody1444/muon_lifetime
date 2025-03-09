`timescale 1ns / 1ps

module button_counter_tb;
    reg clk;
    reg reset;
    reg button;
    reg enable;
    wire [15:0] digits;

    // Instantiate the Device Under Test (DUT)
    button_counter uut (
        .clk(clk),
        .reset(reset),
        .button(button),
        .enable(enable),
        .digits(digits)
    );

    // Generate a 100MHz clock (10ns period)
    always #5 clk = ~clk;

    initial begin
        $display("Testing Button Counter");
        $dumpfile("sim/button_counter_tb.vcd"); // Save waveform
        $dumpvars(0, button_counter_tb);

        clk = 0;
        reset = 1;
        button = 0;
        enable = 1;

        #50 reset = 0;  // Deassert reset after 50ns
        
        // Simulating a button press (rising edge)
        #100 button = 1;  // Press button
        #100 button = 0;  // Release button
        #200;

        // Simulating multiple quick presses
        #100 button = 1;  
        #100 button = 0;  
        #100 button = 1;  
        #100 button = 0;  
        #200;

        // Disabling counter (should stop counting)
        #100 enable = 0;
        #100 button = 1;  // Press while disabled
        #100 button = 0;  // Release while disabled
        #200 enable = 1;  // Re-enable

        // Simulating button press after re-enabling
        #100 button = 1;
        #100 button = 0;

        // Checking reset functionality
        #200 reset = 1; // Apply reset
        #50 reset = 0;  // Deassert reset

        #500;  // Allow some time before stopping

        $display("Test Complete");
        $finish;
    end
endmodule

