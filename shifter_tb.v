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
  
  initial begin
    
    // Test case 1
    direction = 0; //left
    distance = 3'b010;
    in = 5'b10000;
    expected = 5'b00010;
    #5
    $display ("%b -> %b, expected %b", in, out, expected);
    
    // Test case 2
    direction = 0; //left
    distance = 3'b001;
    in = 5'b10010;
    expected = 5'b00101;
    #5
    $display ("%b -> %b, expected %b", in, out, expected);
    
    // Test case 2
    direction = 1; //right
    distance = 3'b011;
    in = 5'b11000;
    expected = 5'b00011;
    #5
    $display ("%b -> %b, expected %b", in, out, expected);
    
    // Test case 4
    direction = 1; //right
    distance = 3'b101;
    in = 5'b10000;
    expected = 5'b10000;
    #5
    $display ("%b -> %b, expected %b", in, out, expected);

    // Test case 5
    direction = 0; //left
    distance = 3'b010;
    in = 5'b01100;
    expected = 5'b00011;
    #5
    $display ("%b -> %b, expected %b", in, out, expected);


endmodule
