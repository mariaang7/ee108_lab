module float_add (
    input wire [7:0] aIn,
    input wire [7:0] bIn,
    output wire [7:0] result
);
   
    wire [7:0] greater_number;
    wire [7:0] smaller_number;
    wire [4:0] shifted_output;
    wire [4:0] sum_ab;
    wire cout;
    wire [4:0] shifted_mantissa;
    wire [2:0] final_exp;

    big_number_first number (.aIn(aIn), .bIn(bIn), .aOut(greater number), .bOut(smaller_number));
    shifter shift_exp (.in(bOut[4:0]), .dir(1), .dis(aOut[7:5] - bOut[7:5]), .out(shifted_output));
    adder added_numbers (.a(aOut[4:0]), .b(bOut[4:0]), .sum(sum_ab), .cout(cout));
    shifter shift_mantissa (.in(sum_ab), .dir(1), .dis(cout), .out(shifted_mantissa));
    
    assign final_exp = aOut[7:5] + {2'b0,1};
    assign result = {final_exp,sum_ab}
endmodule
