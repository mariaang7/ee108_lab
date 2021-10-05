module hash_round #(parameter ROUND) (
	input wire [7:0] in_byte,
	input wire [31:0] in_state,
	output wire [7:0] out_state
);
   
	// Declarations
	wire [7:0] d;
	wire [7:0] c;
	wire [7:0] b;
	wire [7:0] a;
	wire [7:0] mixed_a = (mix(d, c, b) + a) + in_byte;
	wire [7:0] rotated_mixed_a;
	
	// State splitting
	assign {d, c, b, a} = in_state;
	
	// Mix function
	function [7:0] mix;
		input [7:0] d, c, b;
		input [2:0] ROUND;
		output [7:0] mixed;
		always @(*) begin
			if (ROUND == 3'b000 || ROUND == 3'b001 || ROUND == 3'b010)
				mixed = (c & b) | (~b & d);
			else if (ROUND == 3'b011 || ROUND == 3'b100)
				mixed = (c & b) | (b & d) | (d & c);
			else if (ROUND == 3'b101 || ROUND == 3'b110 || ROUND == 3'b111)
				mixed = c ^ b ^ d;
		end
	endfunction
					
	// Rotator
	rotator #(WIDTH = 8) rotator_mix (.in(mixed_a), .direction(1'b1), .distance(ROUND), .out(rotated_mixed_a));
	
	// Output state assignment
	assign out_state = {c, b, rotated_mixed_a, d};

endmodule
