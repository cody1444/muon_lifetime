module digit_extractor (
    input [15:0] digits_A,  // First 4 digits
    input [15:0] digits_B,  // Second 4 digits
    input [2:0] digit_index, // 3-bit index (0-7)
    output reg [3:0] extracted_digit // Selected 4-bit digit
);

    always @(*) begin
        if (digit_index < 4) begin
            case (digit_index)
                3'd0: extracted_digit = digits_A[3:0];  
                3'd1: extracted_digit = digits_A[7:4];
                3'd2: extracted_digit = digits_A[11:8];
                3'd3: extracted_digit = digits_A[15:12];
            endcase
        end else begin
            case (digit_index - 4)  // Adjust index for digits_B
                3'd0: extracted_digit = digits_B[3:0];  
                3'd1: extracted_digit = digits_B[7:4];
                3'd2: extracted_digit = digits_B[11:8];
                3'd3: extracted_digit = digits_B[15:12];
            endcase
        end
    end

endmodule

