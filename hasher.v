module hasher #(parameter ROUND) (
  input wire [63:0] data,
  input wire [3:0] data_len,
  output wire [31:0] hash
);
  
  
