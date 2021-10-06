module hasher (
  input wire [63:0] data,
  input wire [3:0] data_len,
  output wire [31:0] hash
);
  
  	wire dir;
	wire [31:0] final_state = out_six ^ out_seven;
	wire [31:0] out_zero, out_one, out_two, out_three, out_four, out_five, out_six, out_seven;    // outputs of the single hash_rounds
	
	
  
assign in_byte = {data_len, data};
	
  
  
  always @(*) begin
    case (data_len)
	      4'b0000 : dir = 1'b0;
        default : dir = 1'b1
	    endcase
end
		
		hash_round #(WIDTH=0) round_zero (.in_byte(data[0]), .in_state(32'h55555555), .out_state(out_zero))
		hash_round #(WIDTH=1) round_one (.in_byte(data[1]), .in_state(32'hAAAAAAAA), .out_state(out_one));
	    hash_round #(WIDTH=2) round_two (.in_byte(data[2]), .in_state(out_zero), .out_state(out_two));
	    hash_round #(WIDTH=3) round_three (.in_byte(data[3]), .in_state(out_one), .out_state(out_three));
	    hash_round #(WIDTH=4) round_four (.in_byte(data[4]), .in_state(out_two), .out_state(out_four));
	    hash_round #(WIDTH=5) round_five (.in_byte(data[5]), .in_state(out_three), .out_state(out_five));
	    hash_round #(WIDTH=6) round_six (.in_byte(data[6]), .in_state(out_four), .out_state(out_six));
	    hash_round #(WIDTH=7) round_seven (.in_byte(data[7]), .in_state(out_four), .out_state(out_seven));
	    
	    rotator #(WIDTH=32) final_rotator (.in(final_state), .direction(dir), .distance(final_state[4:0]), .out());
  
  
endmodule 
  
