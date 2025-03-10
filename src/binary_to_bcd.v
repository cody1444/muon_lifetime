module binary_to_bcd (
    input [15:0] binary,  // 16-bit Binary Input
    output reg [15:0] bcd // 16-bit BCD Output: [Thousands][Hundreds][Tens][Ones]
);
    integer i;
    reg [31:0] shift_reg; // 32-bit register for shifting

    always @(*) begin
        shift_reg = {16'd0, binary}; // Initialize shift register with binary value
        for (i = 0; i < 16; i = i + 1) begin
            // If any BCD digit is >= 5, add 3 (correction step)
            if (shift_reg[19:16] >= 5) shift_reg[19:16] = shift_reg[19:16] + 3;
            if (shift_reg[23:20] >= 5) shift_reg[23:20] = shift_reg[23:20] + 3;
            if (shift_reg[27:24] >= 5) shift_reg[27:24] = shift_reg[27:24] + 3;
            if (shift_reg[31:28] >= 5) shift_reg[31:28] = shift_reg[31:28] + 3;

            // Shift left by 1 bit
            shift_reg = shift_reg << 1;
        end
        // Extract BCD result
        bcd = shift_reg[31:16]; // Extract [Thousands][Hundreds][Tens][Ones]
    end
endmodule

