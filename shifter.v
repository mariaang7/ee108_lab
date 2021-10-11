module shifter (
  input wire [4:0] in,
  input wire [2:0] distance,
  input wire direction,
  output reg [4:0] out
);

  always @(*) begin
    case (in)
      0'b0: out = in << distance;
      0'b1: out = in >> distance;
    endcase
  end

endmodule
