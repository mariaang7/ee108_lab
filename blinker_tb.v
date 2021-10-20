module blinker_tb ();
  wire switch;
  wire clock, reset, out;
  reg switch;
  reg next_out;
  blinker #(1) blinker(switch, out, clock, reset);
    initial 
        forever
            begin 
              #5 clock = 1; #5 clock = 0;
              $display("%b %b %b %b %b", reset, clock, out, next_out, switch);
            end
     initial begin
        #10
         reset = 0;
        #20
         reset = 1;
        #10
         reset = 0;
        #10 
         switch = 1;
        #350
         switch = 0;
        #30
        $stop;
     end 
endmodule
