module shifter_tb ();
    reg shift_left1, shift_right1, shift_left2, shift_right2, clk, rst;
    wire [8:0] out1, out2;
    
    shifter #(0) dut1 (.shift_left(shift_left1), .shift_right(shift_right1), .clk(clk), .rst(rst), .out(out1));
    shifter #(1) dut2 (.shift_left(shift_left2), .shift_right(shift_right2), .clk(clk), .rst(rst), .out(out2));
    
    initial 
        forever
            begin 
                #5 clk = 1; #5 clk = 0;
                $display("%b %b %b %b %b %b", rst, clk, shift_left1, shift_right1, shift_left2, shift_right2);
            end
            initial begin
        #10
        rst = 0;
        #20
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
       
        $stop;
     end 
endmodule
