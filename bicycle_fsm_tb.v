module bicycle_fsm_tb ();

  wire clk;
  wire faster;
  wire slower;
  wire next;
  wire reset;
  reg rear_light;
  
  bicycle_fsm #(FLASH) bicycle(.clk(clk), .faster(faster), .slower(slower), .next(next), .reset(reset), .rear_lights(rear_lights));
    initial 
        forever
            begin 
                #5 clock = 1; #5 clock = 0;
              $display("%b %b %b %b %b %b", reset, clk, faster, slower, next, rear_lights);
            end
     initial begin
        #10
         reset = 0;
        #20
         reset = 1;
        #10
         reset = 0;
        #10 
         next = 1;
        #10 
         next = 0;
        #10
         faster = 1;
        #10
         faster = 0;
        #10
         slower = 1;
        #10
         slower = 0;
        $stop;
     end 
endmodule
