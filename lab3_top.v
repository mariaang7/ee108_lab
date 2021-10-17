// Lab 3: Bicycle Light
//
// This module is the top-level module for the rear bicycle light.
//
// The inputs to the module are a clock, and four buttons: left, right, up, and
// down. The output of the module is rear_light (the bicycle light following
// the specified behavior).

module lab3_top (
    // System Clock (125MHz)
    input sysclk,

    input [3:0] btn,
    output wire [3:0] leds
);  

    // Clock converter
    wire clk_100;
    wire LED0;      // TODO: assign this to a real LED
 
    clk_wiz_0 U2 (
        .clk_out1(clk_100),     // 100 MHz
        .reset(reset),
        .locked(LED0),
        .clk_in1(sysclk)
    );

    assign {reset_button, next_state_button, slower_button, faster_button} = btn;
    
    wire reset = reset_button;  // btn3 pushed to reset
    wire next_state;            // btn2 pushed to next state
    wire slower;                // btn1 button pushed to decrement speed modifier
    wire faster;                // btn0 button pushed to increment speed modifier


    wire rear_light;
    assign leds = {4{rear_light}}; // a really bright light!

    // *************************************************************************
    // Button press units: synchronize, debouce and one-pulse button presses
    // *************************************************************************

    /* For simulation, you'll want to comment out the button press units (since
     * they count for several ms to debounce the switch) and uncomment the
     * assignments.  For the hardware, we need the synchronization, debouncing,
     * and one-pulsing of the button_press_unit, so comment out the assignment
     * and uncomment the instantiations before synthesizing.
     */

    // Uncomment instantiations for synthesis
    
    button_press_unit bpu_right(
        .clk(clk_100),
        .reset(reset),
        .in(next_state_button),
        .out(next_state)
    );
    button_press_unit bpu_up(
        .clk(clk_100),
        .reset(reset),
        .in(faster_button),
        .out(faster)
    );
    button_press_unit bpu_down(
        .clk(clk_100),
        .reset(reset),
        .in(slower_button),
        .out(slower)
    );
    

    // Comment out these assignments for synthesis;
    // leave them in during simulation
    //assign next_state = next_state_button;
    //assign faster = faster_button;
    //assign slower = slower_button;

    // *************************************************************************
    // Bicycle FSM -- to be completed
    // *************************************************************************

    bicycle_fsm bicycle_fsm(
        .clk(clk_100),
        .reset(reset),
        .faster(faster),
        .slower(slower),
        .next(next_state),
        .rear_light(rear_light)
    );

endmodule
