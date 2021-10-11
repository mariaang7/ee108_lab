module big_number_first_tb ();
  
  reg [7:0] aIn, bIn;
  wire [7:0] aOut, bOut;
  reg [7:0] expected_aOut, expected_bOut;
  big_number_first dut (.aIn(aIn), .bIn(bIn), .aOut(aOut), .bOut(bOut));


initial begin
        // Basic test case #1
        aIn = 8'b00000110;
        bIn = 8'b10011010;
        expected_aOut = 8'b10011010;
        expected_bOut = 8'b00000110;
        #5
        $display("%b -> %b, expected %b", aIn, bIn, aOut, bOut, expected_aOut, expected_bOut);
        
        // Basic test case #2
        aIn = 8'b00000001;
        bIn = 8'b10000000;
        expected_aOut = 8'b10000000;
        expected_bOut = 8'b00000001;
        #5
        $display("%b -> %b, expected %b", aIn, bIn, aOut, bOut, expected_aOut, expected_bOut);
  
        // Basic test case #3
        aIn = 8'b11000100;
        bIn = 8'b10011010;
        expected_aOut = 8'b11000100;
        expected_bOut = 8'b10011010;
        #5
        $display("%b -> %b, expected %b", aIn, bIn, aOut, bOut, expected_aOut, expected_bOut);
  
        // Basic test case #4
        aIn = 8'b00001000;
        bIn = 8'000001000;
        expected_aOut = 8'b00001000;
        expected_bOut = 8'b00001000;
        #5
        $display("%b -> %b, expected %b", aIn, bIn, aOut, bOut, expected_aOut, expected_bOut);
  
  
    end



endmodule
