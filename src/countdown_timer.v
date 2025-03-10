module countdown_timer #(
    parameter COUNTDOWN_CYCLES = 5_000_000
)(
    input clk,
    input start,
    input stop,
    output reg done
);

    reg [31:0] count = 0; // Timer counter
    reg timer_active = 0; // Tracks if countdown is running

    always @(posedge clk) begin
        // Start countdown if A or B is pressed and timer is inactive
        if ((button_A || button_B) && !timer_active) begin
            count <= COUNTDOWN_CYCLES;
            timer_active <= 1;
            done <= 0; // Clear 'done' when countdown starts
        end 

        // Countdown logic
        if (timer_active && count > 0) begin
            count <= count - 1;
            if (count == 1) begin
                done <= 1;
                timer_active <= 0; // Stop timer
            end
        end 
    end
endmodule
