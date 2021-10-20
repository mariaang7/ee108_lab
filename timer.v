module timer (input wire count_en,
              input wire [8:0] load_value,
              input wire clock,
              input wire reset,
              output wire out

  );
  
  reg [8:0] next_state;
  wire [8:0] state; 
  reg load;
  reg next_out;
  
  dffre #(9) counter(.clk(clock), .r(reset), .en(count_en), .d(next_state), .q(state));
  dffr #(1) states(.clk(clock), .r(reset), .d(next_out), .q(out));  
  
  always @(*) begin
    casex({reset, count_en, load})
      3'b1xx: next_state = load_value;
      3'b010: next_state = count_en ? state - 1 : state;
      3'b011: next_state = count_en ? load_value : state;
      default: next_state = next_state; 
    endcase
  end 
  
  always @(*) begin
    case(state) 
      1'b0: load = ~reset ? 1'b1 : 1'b0; 
      default: load = 1'b0;
    endcase
    
  end 
  
  always @(*) begin 
    casex({reset, out, load}) 
      3'b1xx: next_out = 1'b0;
      3'b001: next_out = 1'b1;
      default: next_out = 1'b0;
    endcase
    
  end 

endmodule
