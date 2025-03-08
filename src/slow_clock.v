module slow_clock (
    input clk,
    output reg clk_1kHz
);

    reg [16:0] counter = 0;

    initial begin
        clk_1kHz = 0;
    end

    always @(posedge clk) begin
        if (counter == 49999) begin
            counter <= 0;
            clk_1kHz = ~clk_1kHz;
        end else begin
            counter <= counter + 1;
        end
    end
endmodule
