module wave_display_tb ();

reg clk, reset, valid, read_index;
reg [10:0] x;
reg [9:0]  y; 
reg [7:0] read_value;
wire [8:0] read_address;
wire valid_pixel;
wire [7:0] r, g, b;

wire [10:0] start_x, end_x;
wire [9:0] start_y, end_y;
wire [2:0] display;

wave_display dut(
    .clk(clk),
    .reset(reset),
    .x(x),  // [0..1279]
    .y(y),  // [0..1023]
    .valid(valid),
    .read_value(read_value),
    .read_index(read_index),
    .start_x(start_x),
    .end_x(end_x),
    .start_y(start_y),
    .end_y(end_y),
    .display(display),
    .read_address(read_address),
    .valid_pixel(valid_pixel),
    .r(r),
    .g(g),
    .b(b)
    );
    
    reg btn1, btn2, btn3;
 
    
    wf_limits wf_dut(
        .clk(clk),
        .rst(reset),
        .btn1(btn1),
        .btn2(btn2),
        .btn3(btn3),
        .start_x(start_x),
        .end_x(end_x),
        .start_y(start_y),
        .end_y(end_y),
        .display(display)
    );

    // Clock and reset
    initial begin
        clk = 1'b0;
        reset = 1'b1;
        repeat (4) #5 clk = ~clk;
        reset = 1'b0;
        forever #5 clk = ~clk;
  

    end

    // Tests
    initial begin
        valid = 1;
        x = 11'b00000000101;
        y = 10'b0010010110;
        read_value = 8'b01100100;
        read_index = 1;
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
