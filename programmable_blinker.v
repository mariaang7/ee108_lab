module programmable_blinker (
  input wire shift_left, shift_right,
  input clock,
  input reset,
  output wire out
);

  
  shifter jeff (.shift_left(shift_left), .shift_right(shift_right), .clk(clock), .rst(reset), .out());
 

endmodule
