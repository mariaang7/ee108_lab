module timer_tb ();
  reg clock, reset, count_en;
  reg [8:0] load_value;
  wire out;
  
  
    
  timer times(count_en, load_value, clock, reset, out);
    initial 
        forever
            begin 
                #5 clock = 1; #5 clock = 0;
                //$display("%b %b %b %b %b %b %b %b %b %b", reset, clock, state, faster, slower, next, shift_left_1, shift_left_2, shift_right_1, shift_right_2);
            end
     initial begin
        #10 
         load_value = 001000000;
        #10
         reset = 0;
        #20
         reset = 1;
        #10
         reset = 0;
        #10 
         count_en = 1;
        #700
         count_en = 0;
        #30
        $stop;
     end 
endmodule 
