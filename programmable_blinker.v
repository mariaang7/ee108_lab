module programmable_blinker (
  input clock,
  input reset,
  output wire out
);

  wire [8:0] shifter_out;
  wire [8:0] load_value_timer;
  wire count;
  wire timer_out;
  
  master
  beat32 may (.clock(clock), .reset(reset), .count(count));
  shifter jeff #()(.shift_left(shift_left), .shift_right(shift_right), .clk(clock), .rst(reset), .out(shifter_out));
  timer joe (.count_en(count), .load_value(load_value_timer), .clock(clock), .reset(reset), .out());
  blinker nin (.switch(timer_out), .clock(clock), .reset(reset), .out(out));
 

endmodule
