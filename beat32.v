module beat32 (
  input wire clock,
  input wire reset,
  output reg count
);
  //3125000
  wire [21:0] state;
  reg [21:0] next_state;
  dffr #(22) counter(.clk (clock),.r (reset),.d (next_state), .q (state));
  
  always @(*) begin
    case(state)
      //uncomment next line for testbench and comment original
      //22'd6: next_state = 0;
      22'd3124999: next_state = 0;
      default: next_state = state + 1;
    endcase
     if (reset) begin
        next_state = 0;
     end else begin
        next_state = next_state;
     end
  end
  
  always @(*) begin
    //uncomment next line for testbench and comment original
    if (state == 0) begin
    //if (state == 3125000) begin
      assign count = 1;
    end else begin
      assign count = 0;
    end
  end
 
endmodule
