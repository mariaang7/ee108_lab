module big_number_first ( input wire [7:0] aIn,
                         input wire [7:0] bIn,
                         input wire [7:0] aOut, 
                         input wire [7:0] bIn

);
  
  assign aOut = aIn >= bIn ? aIn:bIn;
  assign bOut = bIn >= aIn ? aIn:bIn;
  
endmodule
