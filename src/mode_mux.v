module mode_mux (
    input [1:0] mode,   // 2-bit mode selection
    input [6:0] segments_mode_0, segments_mode_1, segments_mode_2,
    input [7:0] anodes_mode_0, anodes_mode_1, anodes_mode_2,
    output reg [6:0] segments,
    output reg [7:0] anodes
);

    always @(*) begin
        case (mode)
            2'b00: begin
                segments = segments_mode_0;
                anodes = anodes_mode_0;
            end
            2'b01: begin
                segments = segments_mode_1;
                anodes = anodes_mode_1;
            end
            2'b10: begin
                segments = segments_mode_2;
                anodes = anodes_mode_2;
            end
            2'b11: begin
                segments = 7'b1111111;  // Blank display (All segments off)
                anodes = 8'b11111111;   // All anodes off
            end
            default: begin
                segments = segments_mode_0;
                anodes = anodes_mode_0;
            end
        endcase
    end
endmodule

