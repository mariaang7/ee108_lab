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
		
		hash_round #(WIDTH=0) round_zero (.in_byte(data[0]), .in_state(32'h55555555), .out_state(ROUND))
		hash_round #(WIDTH=1) round_one (.in_byte(data[1]), .in_state(32'hAAAAAAAA), .out_state(ROUND));
	    hash_round #(WIDTH=2) round_two (.in_byte(data[2]), .in_state(1'b1), .out_state(ROUND),);
	    hash_round #(WIDTH=3) round_three (.in_byte(data[3]), .in_state(1'b1), .out_state(ROUND));
	    hash_round #(WIDTH=4) round_four (.in_byte(data[4]), .in_state(1'b1), .out_state(ROUND));
	    hash_round #(WIDTH=5) round_five (.in_byte(data[5]), .in_state(1'b1), .out_state(ROUND));
	    hash_round #(WIDTH=6) round_six (.in_byte(data[6]), .in_state(1'b1), .out_state(ROUND));
	    hash_round #(WIDTH=7) round_seven (.in_byte(data[7]), .in_state(1'b1), .out_state(ROUND));
	    
 	rotator #(WIDTH=32) final_rotator (.in(mixed_a), .direction(1'b1), .distance(ROUND), .out(rotated_mixed_a));
  
  
endmodule 
  
