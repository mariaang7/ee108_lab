module blinker (input wire switch,
                input wire out,
                input wire clock,
                input wire reset

);

  reg next_switch;
  dffr #(1) blinker(.clk(clock), .r(reset), .d(next_switch), .q(out));
  
  always @(*) begin
    case (out) 
      1'b0: next_switch = 1'b1;
      1'b1: next_switch = 1'b0;
    default: next_switch = 1'b0;
    endcase 
  end
  

endmodule
