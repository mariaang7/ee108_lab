module shifter_tb ();
  reg [4:0] in;
  reg [2:0] distance;
  reg direction;
  reg expected;
  wire [4:0] out;
  shifter dut (
    .in(in), 
    .distance(distance),
    .direction(direction),
    .out(out)
  );




endmodule
