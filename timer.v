module timer (input wire count_en,
              input reg [x:0] load_value,
              input wire clock,
              input wire reset,
              output reg out

);

  dffre #(x+1) counter(.clk(clock), .r(reset), .en(count_en), .d(load_value));
  
  always @(*) begin
    if (count_en) begin
      load_value = load_value - 1;
      if (load_value == 0) begin
        out = 1'b1;
      end 
      else begin 
        out = 1'b0;
      end 
    end 
    else begin
      load_value = load_value; 
    end 
  end 
  
  always @(*) begin
    if (reset) begin
      count_en = 1'b0;
      end 
    else begin 
      count_en = count_en;
      end 
  end

endmodule
