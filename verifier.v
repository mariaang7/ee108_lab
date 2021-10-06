
module verifier (
  input wire [63:0] username,
  input wire [63:0] password,
  output wire valid_out
);
  wire [3:0] password_data_len;
  wire [31:0] a,b;
  wire [3:0] username_data_len;
  wire [2:0] cam_addr;
  wire cam_valid;
  wire out;

  
  
  
  length_finder password_length (.string(password), .length(password_data_len));
  length_finder username_length (.string(username), .length(username_data_len));
  hasher password_hasher (.data(password), .data_len(password_data_len), .hash(a));
  cam cam_username (.data_len(username_data_len), .data(username), .addr(cam_addr), .valid(cam_valid));
  hash_rom rom_password (.addr(cam_addr), .data(b));
  
  assign out = (a == b) ? 1'b1 : 1'b0;
  assign valid_out = (cam_valid & out);
  
endmodule 
