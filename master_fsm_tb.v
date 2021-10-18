module master_fsm_tb ();
    reg clock, reset, slower, faster, next;
    wire shift_right_1, shift_right_2, shift_left_1, shift_left_2;
    reg [2:0] next_state;
    wire [2:0] state;
    
    master_fsm master(next, slower, faster, state, shift_left_1, shift_left_2, shift_right_1, shift_right_2, clock, reset);
    initial 
        forever
            begin 
                #5 clock = 1; #5 clock = 0;
                $display("%b %b %b %b %b %b %b %b %b %b", reset, clock, state, faster, slower, next, shift_left_1, shift_left_2, shift_right_1, shift_right_2);
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
        #30
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
