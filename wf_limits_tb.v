module wf_limits_tb();

    reg clk, rst;
    reg btn1, btn2, btn3;
    wire [9:0] start_x, end_x, start_y, end_y;
    
    wf_limits dut(
        .clk(clk),
        .rst(rst),
        .btn1(btn1),
        .btn2(btn2),
        .btn3(btn3),
        .start_x(start_x),
        .end_x(end_x),
        .start_y(start_y),
        .end_y(end_y)
    );

    // Clock and reset
    initial begin
        clk = 1'b0;
        rst = 1'b1;
        repeat (4) #5 clk = ~clk;
        rst = 1'b0;
        forever #5 clk = ~clk;
  

    end

    // Tests
    initial begin
       btn1 = 1'b0;
       btn2 = 1'b0;
       btn3 = 1'b0;
       #10
       btn1 = 1'b1;
       #40
       btn1 = 1'b0;
       btn2 = 1'b1;
       #80
       btn2 = 1'b0;
       btn3 = 1'b1;
       #80
        
        
        $stop;
    end

endmodule

