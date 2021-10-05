module length_finder (
   input wire [63:0] string,
   output wire [3:0] length
);
   
	wire [7:0] is_character_null;
	wire [7:0] first_null_character;
	
	assign is_character_null[0] = ~(|string[63:56]);
	assign is_character_null[1] = ~(|string[55:48]);
	assign is_character_null[2] = ~(|string[47:40]);
	assign is_character_null[3] = ~(|string[39:32]);
	assign is_character_null[4] = ~(|string[31:24]);
	assign is_character_null[5] = ~(|string[23:16]);
	assign is_character_null[6] = ~(|string[15:8]);
	assign is_character_null[7] = ~(|string[7:0]);
	
	arbiter arbiter_for_null_byte (.in(is_character_null), .out(first_null_character));
	encoder find_length (.in(first_null_character), .out(length[2:0]));
	
	assign length[3] = (is_character_null == 0) ? 1'b1 : 1'b0;
  
endmodule
