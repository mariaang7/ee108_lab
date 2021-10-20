module timer (input wire count_en,
              input wire [8:0] load_value,
              input wire clock,
              input wire reset,
              output reg out

  );
  
  reg [8:0] next_state;
  wire state; 
  wire [8:0] value = load_value - 1;
  reg next_out;
  
  dffre #(9) counter(.clk(clock), .r(reset), .en(count_en), .d(next_state), .q(state));
  dffr #(1) states(.clk(clock), .r(reset), .d(next_out), .q(out));  
  
  
  always @(*) begin
    if (reset) begin
      next_state = 0;
    end
    else 
      case (state)
        1'b0: next_state = count_en ? load_value : 1'b0; 
              out = 1'b1; 
        default: next_state = count_en ? state - 1 : state;
              out = 1'b0;
      endcase
    
  end 
  
  always @(*) begin
    if (reset) begin
      
    end 
  end 
  
  

endmodule
