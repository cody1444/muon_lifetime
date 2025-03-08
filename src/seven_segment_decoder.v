module seven_segment_decoder (
	input [3:0] digit,
	output reg [6:0] segments
);

	initial segments = 7'b1111111; // Initial state (blank/dim display)

	always @(*) begin
		case (digit)
			4'd0: segments = 7'b0000001;
			4'd1: segments = 7'b1001111;
			4'd2: segments = 7'b0010010;
			4'd3: segments = 7'b0000110;
			4'd4: segments = 7'b1001100;
			4'd5: segments = 7'b0100100;
			4'd6: segments = 7'b0100000;
			4'd7: segments = 7'b0001111;
			4'd8: segments = 7'b0000000;
			4'd9: segments = 7'b0000100;
			default: segments = 7'b1111111; // If invalid, blank display
		endcase
	end
endmodule
