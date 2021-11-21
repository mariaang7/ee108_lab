module time_advancer (
input clk;
input reset;
input [5:0] duration;
input beat;
output advance_done;
);

 wire [5:0] state, next_state;
    dffre #(.WIDTH(6)) state_reg (
        .clk(clk),
        .r(reset),
        .en(beat),
        .d(next_state),
        .q(state)
    );
    assign next_state = (reset) ? duration : state - 1;

    assign advance_done = (state == 6'b0) && beat;

endmodule
