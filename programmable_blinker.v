module programmable_blinker (
  input wire shift_left, shift_right,
  input clock,
  input reset,
  output wire out
);

  wire [8:0] shifter_out;
  wire count;
  wire timer_out;
  
  beat32 may (.clock(clock), .reset(reset), .count(count));
  shifter #() jeff (.shift_left(shift_left), .shift_right(shift_right), .clk(clock), .rst(reset), .out(shifter_out));
  timer joe (.count_en(count), .load_value(shifter_out), .clock(clock), .reset(reset), .out());
  blinker nin (.switch(timer_out), .clock(clock), .reset(reset), .out(out));
 

endmodule
