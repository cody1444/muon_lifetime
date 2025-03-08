module mode_select (
    input sw_mode,  // Switch input for mode selection
    output wire mode  // Directly pass switch state as mode
);

    assign mode = sw_mode;  // Mode follows switch position

endmodule
