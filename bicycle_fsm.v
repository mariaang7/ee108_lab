// Bicycle Light FSM
//
// This module determines how the light functions in the given state and what
// the next state is for the given state.
// 
// It is a structural module: it just instantiates other modules and hooks
// up the wires between them correctly.

/* For this lab, you need to implement the finite state machine following the
 * specifications in the lab hand-out */

module bicycle_fsm #(parameter FLASH = 1)(
    input clk, 
    input faster, 
    input slower, 
    input next, 
    input reset, 
    output reg rear_light
);

    wire [2:0] state; 
    wire shift_right_1;
    wire shift_right_2; 
    wire shift_left_1;
    wire shift_left_2;
    wire count_en;
    wire out_1;
    wire out_2;
    
    // Instantiations of master_fsm, beat32, fast_blinker, slow_blinker here
    master_fsm master(.next(next), .slower(slower), .faster(faster), .state(state), .shift_left_1(shift_left_1), .shift_left_2(shift_left_2), .shift_right_1(shift_right_1), .shift_right_1(shift_right_2), .clock(clk), .reset(reset));
    beat_32 beat(.clock(clk), .reset(reset), .count(count_en));
    programmable_blinker #(FLASH) fast(.shift_left(shift_left_1), .shift_right(shift_right_1), .clock(clk), .reset(reset), .out(out_1));
    programmable_blinker #(FLASH) slow(.shift_left(shift_left_2), .shift_right(shift_right_2), .clock(clk), reset(reset), .out(out_2));
    
    // Output mux here
    always @(*) begin
        case (state) 
            3'b111: rear_light =  
        endcase 
    end 
    

endmodule
