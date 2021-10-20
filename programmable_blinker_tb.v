module programmable_blinker_tb ();
  module programmable_blinker #(parameter FLASH = 1)(
  reg shift_left1, shift_right1, shift_left2, shift_right2;
  reg clock;
  reg reset;
  wire out;
  
    programmable binker #(0) dut1 (shift_left1, shift_right1, clk, rst);
    programmable binker #(1) dut1 (shift_left2, shift_right2, clk, rst);
    
    initial 
      forever
        begin
          #5 clock = 1; #5 clock = 0;
          $display("%b %b %b %b %b %b", rst, shift_left1, shift_right1, shift_left2, shift_right2, out);
        end
    
    initial begin
      #10
      rst = 0;
      #10
      rst = 1;
      #10
      rst = 0;
      #10
      shift_left1 = 1;
      shift_right1 = 0;
      #10
      shift_left1 = 0;
      shift_right1 = 0;
      #10
      rst = 1;
      #10
      rst = 0;
      #10
      shift_left2 = 1;
      shift_right2 = 0;
      #10
      shift_left2 = 0;
      shift_right2 = 0;
      #40
      
      $stop;
    end
    
endmodule
