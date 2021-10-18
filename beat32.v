module beat32 (
  input wire clock,
  input wire reset,
  output reg count
);
  //3125000
  reg [21:0] state;
  reg [21:0] next_state;
  dffr #(22) counter(.clk (clock),.r (reset),.d (next_state), .q (state));
  
  assign next_state = state + 1;
  
  always @(*) begin
    case(state)
      22'd3125000: next_state = 0;
      default: next_state = state + 1;
  end
  
  always @(*) begin
    if (state == 3125000) begin
      assign count = 1;
    end else begin
      assign out = 0;
    end
  end
      
  assign next_state = reset ? 0 : next_state;
 
endmodule
