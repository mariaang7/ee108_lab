module hasher (
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
		
		hash_round #(WIDTH=0) round_zero (.in(mixed_a), .direction(1'b1), .distance(ROUND), .out(rotated_mixed_a))
		hash_round #(WIDTH=1) round_one (.in(mixed_a), .direction(1'b1), .distance(ROUND), .out(rotated_mixed_a));
	    hash_round #(WIDTH=2) round_two (.in(mixed_a), .direction(1'b1), .distance(ROUND), .out(rotated_mixed_a));
	    hash_round #(WIDTH=3) round_three (.in(mixed_a), .direction(1'b1), .distance(ROUND), .out(rotated_mixed_a));
	    hash_round #(WIDTH=4) round_four (.in(mixed_a), .direction(1'b1), .distance(ROUND), .out(rotated_mixed_a));
	    hash_round #(WIDTH=5) round_five (.in(mixed_a), .direction(1'b1), .distance(ROUND), .out(rotated_mixed_a));
	    hash_round #(WIDTH=6) round_six (.in(mixed_a), .direction(1'b1), .distance(ROUND), .out(rotated_mixed_a));
	    hash_round #(WIDTH=7) round_seven (.in(mixed_a), .direction(1'b1), .distance(ROUND), .out(rotated_mixed_a));
	    
 	rotator #(WIDTH=32) final_rotator (.in(mixed_a), .direction(1'b1), .distance(ROUND), .out(rotated_mixed_a));
  
  
endmodule 
  
