module timer (module timer (input wire count_en,
              input wire [8:0] load_value,
              input wire clock,
              input wire reset,
              output reg out

  );
  
  reg [8:0] next_state;
  wire state; 
  wire [8:0] value;
  reg next_out;
  
  dffre #(9) counter(.clk(clock), .r(reset), .en(count_en), .d(next_state), .q(state));
  dffr #(1) states(.clk(clock), .r(reset), .d(next_out), .q(out));  
  
  dffr #(1) states(.clk(clock), .r(reset), .d(next_out), .q(out));  
  
  always @(*) begin
    case (state) 
      1'b0: next_state = count_en && (value = 0) ? 1'b1 : 1'b0; 
      1'b1: next_state = count_en ? 1'b0 : 1'b1;
      default: next_state = 1'b0;
    endcase 
  end 
  
  always @(*) begin
    case (out) 
      1'b0: next_out = count_en && (value = 0) ? 1'b1 : 1'b0; 
      1'b1: next_out = count_en ? 1'b0 : 1'b1;
      default: next_out = 1'b0;
    endcase 
  end 
  
  always @(*) begin
    if (state == 1'b0) begin
      value = value - 1;
    end 
    else if (state == 1'b1) begin
      value = load_value;
    end 
    else begin
      value = load_value;
    end 
  end 
  
  always @(*) begin
    if (out == 1'b0) begin
      next_out = 1'b1;
    end 
    else if (out == 1'b0) begin
      next_out = 1'b1;
    end 
    else begin
      next_out = 1'b0;
    end 
  end 

  
  
);
