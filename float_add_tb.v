module float_add_tb ();

  reg [7:0] aIn,bIn;
  reg [7:0] expected;
  wire [7:0] out;
  float_add dut (.aIn(aIn), .bIn(bIn), .result(out));

    initial begin
        // Basic test case #1
        in = 8'b00000110;
        expected = 8'b00000010;
        #5
        $display("%b -> %b, expected %b", in, out, expected);

        // Basic test case #2
        in = 8'b00100000;
        expected = 8'b00100000;
        #5
        $display("%b -> %b, expected %b", in, out, expected);

        // Basic test case #3
        in = 8'b01010100;
        expected = 8'b00000100;
        #5
        $display("%b -> %b, expected %b", in, out, expected);
        
        // Basic test case #4
        in = 8'b01110000;
        expected = 8'b00010000;
        #5
        $display("%b -> %b, expected %b", in, out, expected);
        
        // Basic test case #5
        in = 8'b10000000;
        expected = 8'b10000000;
        #5
        $display("%b -> %b, expected %b", in, out, expected);

    end



endmodule
