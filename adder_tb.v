module adder_tb ();
    reg [4:0] a;
    reg [4:0] b;
    reg [4:0] expected;
    reg [4:0] sum;
    reg cout;
    
    adder add (.a(a), .b(b), .sum(sum), .cout(cout));


initial begin

    a = 5'b00001;
    b = 5'b00010;
    expected = 5'b00011;
    $display("%d, expected %d, cout=%d expected_cout=0", sum , expected, cout);
    
    
    a = 5'b10000;
    b = 5'b00001;
    expected = 5'b10001;
    $display("%d, expected %d, cout=%d expected_cout=0", sum , expected, cout);
    
    
    a = 5'b00000;
    b = 5'b00000;
    expected = 5'b00000;
    $display("%d, expected %d, cout=%d expected_cout=0", sum , expected, cout);
    
    
    a = 5'b11111;
    b = 5'b11111;
    expected = 5'b11110;
    $display("%d, expected %d, cout=%d expected_cout=1", sum , expected, cout);
    

end



endmodule
