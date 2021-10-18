module beat32_tb ();
  reg clock, reset;
  wire count;
  beat32 dud (.clock(clock), .reset(reset), .count(count));
  initial
    forever
      begin
        #5 clock = 1 ; #5 clock = 0 ;
      end
  initial begin
    #10 reset = 0 ;    // start w/o reset to showx state
    #20 reset = 1 ;    // reset
    #10 reset = 0 ;    // remove reset
    #30
    $display("expected: 0 ---> %d", count);
    #40
    $display("expected: 1 ---> %d", count);
    #70
    $display("expected: 1 ---> %d", count);
    #80   // 8 more cycles
    $stop ;
  end
endmodule
