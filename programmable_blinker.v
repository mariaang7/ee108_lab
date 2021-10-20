module programmable_blinker (
  input wire shift_left, shift_right,
  input clock,
  input reset,
  output wire out
);

  wire [9:0] shifter_out;
  wire [8:0] load_value_timer;
  
  beat32 may (.clock(), .reset(), .count()
  shifter jeff (.shift_left(shift_left), .shift_right(shift_right), .clk(clock), .rst(reset), .out(shifter_out));
  timer joe (.load_value(load_value_timer), .clock(clock), .reset(reset), .out());
 

endmodule
