`timescale 1ns / 1ps

module slow_clock_tb;
    reg clk;
    wire clk_1kHz;

    // Instantiate the clock divider module
    slow_clock uut (
        .clk(clk),
        .clk_1kHz(clk_1kHz)
    );

    // Generate a 100MHz clock (period = 10ns)
    always #5 clk = ~clk; // Toggle every 5ns → 100MHz

    initial begin
        $display("Testing Clock Divider");
        $dumpfile("sim/slow_clock_tb.vcd");
        $dumpvars(0, slow_clock_tb);
        
        #40
        clk = 0; // Initialize clock

        #4000000; // Run the simulation for 4ms (to observe multiple 1kHz cycles)

        $display("Test Complete");
        $finish;
    end
endmodule
