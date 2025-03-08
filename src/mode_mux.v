module mode_mux (
    input mode,                  // Mode select signal
    input [6:0] segments_mode_0,  // Segments from full_display_controller
    input [6:0] segments_mode_1,  // Segments from single_display_controller
    input [7:0] anodes_mode_0,    // Anodes from full_display_controller
    input [7:0] anodes_mode_1,    // Anodes from single_display_controller
    output [6:0] segments,        // Final selected segments output
    output [7:0] anodes           // Final selected anodes output
);

    // Multiplex between full and single display controllers
    assign segments = (mode == 0) ? segments_mode_0 : segments_mode_1;
    assign anodes = (mode == 0) ? anodes_mode_0 : anodes_mode_1;

endmodule
