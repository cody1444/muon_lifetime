`timescale 1ns / 1ps

module binary_to_bcd_tb;
    reg [15:0] binary;      // Input: Binary value
    wire [15:0] bcd;        // Output: BCD result

    // Instantiate the Binary to BCD Converter
    binary_to_bcd uut (
        .binary(binary),
        .bcd(bcd)
    );

    initial begin
        $display("Testing Binary to BCD Conversion");
        $monitor("Binary=%d -> BCD=%x (Thousands=%d, Hundreds=%d, Tens=%d, Ones=%d)", 
                 binary, bcd, bcd[15:12], bcd[11:8], bcd[7:4], bcd[3:0]);

        // Enable waveform dump
        $dumpfile("sim/binary_to_bcd_tb.vcd");
        $dumpvars(0, binary_to_bcd_tb);

        // Test Cases
        binary = 16'd0;       #10;
        binary = 16'd5;       #10;
        binary = 16'd12;      #10;
        binary = 16'd99;      #10;
        binary = 16'd123;     #10;
        binary = 16'd256;     #10;
        binary = 16'd1023;    #10;
        binary = 16'd4096;    #10;
        binary = 16'd9999;    #10;
        binary = 16'd65535;   #10;  // Max 16-bit input

        $display("Test Complete");
        $finish;
    end
endmodule

