module rotator_tb ();

    // Test two different widths of rotator

    reg [7:0] in_8;
    reg [7:0] expected_8;
    wire [7:0] out_8;
    reg [7:0] distance_8;
    reg direction_8;
    rotator #(.WIDTH(8)) dut_8 (
        .in(in_8),
        .out(out_8),
        .distance(distance_8),
        .direction(direction_8)
    );

    reg [31:0] in_32;
    reg [31:0] expected_32;
    wire [31:0] out_32;
    reg [7:0] distance_32;
    reg direction_32;
    rotator #(.WIDTH(32)) dut_32 (
        .in(in_32),
        .out(out_32),
        .distance(distance_32),
        .direction(direction_32)
    );

    initial begin
        ////// 8-bit tests ////////////////////

        // Basic test cases
        direction_8 = 0;
        distance_8 = 8'd2;
        in_8 = 8'b00010000;
        expected_8 = 8'b00000100;
        #5
        $display ("%b -> %b, expected %b", in_8, out_8, expected_8);

        direction_8 = 1;
        distance_8 = 8'd4;
        in_8 = 8'b00000100;
        expected_8 = 8'b01000000;
        #5
        $display ("%b -> %b, expected %b", in_8, out_8, expected_8);

        // Add more test cases here, including edge cases.
      
        direction_8 = 0;
        distance_8 = 8'd4;
        in_8 = 8'b00000010;
        expected_8 = 8'b00100000;
        #5
        $display ("%b -> %b, expected %b", in_8, out_8, expected_8);
      
        direction_8 = 1;
        distance_8 = 8'd5;
        in_8 = 8'b01000000;
        expected_8 = 8'b00001000;
        #5
        $display ("%b -> %b, expected %b", in_8, out_8, expected_8);
        


        ////// 32-bit tests ///////////////////
        // Don't worry about repeating ALL of your 8-bit tests here, the point is
        // just to make sure that parameterization of the module works correctly.
        // Basic tests will suffice, edge case tests aren't necessary for this lab

        // Add basic 32-bit test cases here
      
        direction_32 = 0;
        distance_32 = 8'd2;
        in_32 = 32'b10000000000000000000000000000000;
        expected_32 = 32'b00100000000000000000000000000000;
        #5
        $display ("%b -> %b, expected %b", in_32, out_32, expected_32);
      
        direction_32 = 1;
        distance_32 = 8'd2;
        in_32 = 32'b00000000000000000000000000000001;
        expected_32 = 32'b00000000000000000000000000000100;
        #5
        $display ("%b -> %b, expected %b", in_32, out_32, expected_32);
    end

endmodule
