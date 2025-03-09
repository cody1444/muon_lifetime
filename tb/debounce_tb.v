`timescale 1ns / 1ps

module debounce_tb;
    reg clock;
    reg reset;
    reg [4:0] button;
    wire [4:0] out;

    // Instantiate the Device Under Test (DUT)
    debounce uut (
        .clock(clock),
        .reset(reset),
        .button(button),
        .out(out)
    );

    // Generate a 100MHz clock (10ns period)
    always #5 clock = ~clock;

    initial begin
        $display("Testing Debounce Module with Human-Like Presses");
        $dumpfile("sim/debounce_tb.vcd"); // Save waveform
        $dumpvars(0, debounce_tb);

        clock = 0;
        reset = 1;
        button = 5'b00000;  // No buttons pressed

        #100;  // Wait for reset
        reset = 0;

        // Simulating a short button press (100ms)
        // #1_000_000 button[0] = 1;  // Press button 0
        // #100_000_000 button[0] = 0;  // Release after 100ms

        // Simulating a longer button press (500ms)
        // #1_000_000 button[1] = 1;  // Press button 1
        // #500_000_000 button[1] = 0;   // Release after 500ms

        // Simulating a very quick accidental tap (10ms, should be ignored)
        #1_000_000 button[2] = 1;  
        #1_000_000 button[2] = 0;  

        #1_000_000;  // Wait before finishing to view final states

        $display("Test Complete");
        $finish;
    end
endmodule

