module blinker (input wire switch,
                output wire out,
                input wire clock,
                input wire reset

);

  reg next_out;
  dffr #(1) blinker(.clk(clock), .r(reset), .d(next_out), .q(out));
  
  always @(*) begin
    case (out) 
      1'b1: next_out = switch ? 1'b0 : 1'b1;
    default: next_out = switch ? 1'b1 : 1'b0;
    endcase 
  end
endmodule
