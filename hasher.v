module hasher #(parameter ROUND) (
  input wire [63:0] data,
  input wire [3:0] data_len,
  output wire [31:0] hash
);
  
  wire dir;
  wire final_state [31:0];
  
assign in_byte = {data_len, data};
	
  
  
  always @(*) begin
    case (data_len)
	      4'b0000 : dir = 1'b0;
        default : dir = 1'b1
	    endcase
	 end
  
  rotator #(WIDTH=32) final_rotator (.in(mixed_a), .direction(1'b1), .distance(ROUND), .out(rotated_mixed_a));
  
  
endmodule 
  
