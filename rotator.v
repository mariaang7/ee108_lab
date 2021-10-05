module rotator #(parameter WIDTH=8) (
   input wire [WIDTH-1:0] in,
   input wire direction,
   input wire [7:0] distance,
   output wire [WIDTH-1:0] out
);

	wire [WIDTH*2-1:0] double_in;
	wire [WIDTH*2-1:0] double_rot_l;	
    wire [WIDTH*2-1:0] double_rot_r;
	wire [WIDTH-1:0] rot_l;
	wire [WIDTH-1:0] rot_r;
	
	assign double_in = {2{in}};
	assign double_rot_r = double_in >> distance;
	assign double_rot_l = double_in << distance;
	assign rot_r = double_rot_r[WIDTH-1:0];
	assign rot_l = double_rot_l[WIDTH*2-1:WIDTH];
	
	assign out = (direction == 1'b1) ? rot_l : rot_r;
	
endmodule
