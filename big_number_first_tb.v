module big_number_first_tb (input wire [7:0] aIn,
                            input wire [7:0] bIn, 
                            output wire [7:0] aOut,
                            output wire [7:0] bOut

);

initial begin
        // Basic test case #1
        aIn = 8'b00000110;
        expected_aIn = 8'b00000010;
        expected_aOut = ;
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
