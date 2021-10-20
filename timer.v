module timer (input wire count_en,
              input reg [8:0] load_value,
              input wire clock,
              input wire reset,
              output reg out

);
  reg [8:0] next_state;
  reg [8:0] state; 
  reg next_out;
  
  dffre #(x+1) counter(.clk(clock), .r(reset), .en(count_en), .d(next_state), .q(state));
  dffr #() states(.clk(clock), .r(reset), .d(next_out), .q(out));  
  
  always @(*) begin
    case(state) 
      1'b0: next_state = count_en ? load_value : 1'b0;
    default: next_state = count_en ? state - 1 : state;
    endcase 
  end 
  
  always @(*) begin
    if (state == 1'b0) begin
      case(out)
        1'b0: next_out = 1'b1;
      default: next_out = 1'b0;
      endcase 
    end 
    else 
      next_out = 1'b0;
    end 
  end 
  
  
  always @(*) begin
    if (reset) begin
      out = 1'b0;
      next_state = load_value;
      end 
    else begin 
      out = out;
      end 
  end

endmodule
