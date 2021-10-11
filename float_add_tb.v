module float_add_tb ();

  reg [7:0] aIn,bIn;
  reg [7:0] expected;
  wire [7:0] out;
  float_add dut (.aIn(aIn), .bIn(bIn), .result(out));

    initial begin
        // Test case #1
        aIn = 8'b00001000;
        bIn = 8'b00000011;
        expected = 8'b00001011;
        #5
        $display("%b -> %b, expected %b", in, out, expected);

        // Test case #2
        aIn = 8'b00110001;
        bIn = 8'b00001100;
        expected = 8'b00110111;
        #5
        $display("%b -> %b, expected %b", in, out, expected);

        // Test case #3
        aIn = 8'b10010010;
        bIn = 8'b01011111;
        expected = 8'b10011001;
        #5
        $display("%b -> %b, expected %b", in, out, expected);
        
        // Test case #4
        aIn = 8'b11111110;
        bIn = 8'b11111000;
        expected = 8'b11111111;
        #5
        $display("%b -> %b, expected %b", in, out, expected);

    end
endmodule
