module hasher #(parameter ROUND) (
  input wire [63:0] data,
  input wire [3:0] data_len,
  output wire [31:0] hash
);
  
  
  rotator #(WIDTH = 8) rotator_mix (.in(mixed_a), .direction(1'b1), .distance(ROUND), .out(rotated_mixed_a));
  
  
endmodule 
  
