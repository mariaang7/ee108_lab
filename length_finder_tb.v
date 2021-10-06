module length_finder_tb ();

   reg [63:0] in;
   reg [3:0] expected;
   wire [3:0] len;
   
   length_finder dut (
      .string (in),
      .length (len)
   );
   
   initial begin
      in = 64'hAABBCCDDEEFFAA00;
      expected = 4'b0111;
      #5
      $display("%b -> %d, expected %d", in,len, expected);
      in = 64'hAABBCCDDEEFFAA99;
      expected = 4'b1000;
      #5
      $display("%b -> %d, expected %d", in, len, expected);
      in = 64'hAABBCCDDEEFF00AA;
      expected = 4'b0110;
      #5
      $display("%b -> %d, expected %d", in, len, expected);
      in = 64'hAABBCCDDEE00FFAA;
      expected = 4'b0101;
      #5
      $display("%b -> %d, expected %d", in, len, expected);
      in = 64'hAABBCC00EE00FFAA;
      expected = 4'b0011;
      #5
      $display("%b -> %d, expected %d", in, len, expected);
      in = 64'h00BBCCDDEE44FFAA;
      expected = 4'b0000;
      #5
      $display("%b -> %d, expected %d", in, len, expected);
      in = 64'h00BBCC00EE44FFAA;
      expected = 4'b0000;
      #5
      $display("%b -> %d, expected %d", in, len, expected);
      in = 64'h44BBC00DEE44FFAA;
      expected = 4'b1000;
      #5
      $display("%b -> %d, expected %d", in, len, expected);
      in = 0;
      expected = 4'b1000;
      $display("%b -> %d, expected %d", in, len, expected);
   end
   
endmodule
