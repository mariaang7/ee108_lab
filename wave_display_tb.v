module wave_display_tb ();


reg clk, reset, valid, read_index;
reg [10:0] x;
reg [9:0]  y; 
reg [7:0] read_value;
wire [8:0] read_address;
wire valid_pixel;
wire [7:0] r, g, b;

wave_display_dut (
    .clk(clk),
    .reset(reset),
    .x(x),  // [0..1279]
    .y(y),  // [0..1023]
    .valid(valid),
    .read_value(read_value),
    .read_index(read_index),
    .read_address(read_address),
    .valid_pixel(valid_pixel),
    .r(r),
    .g(g),
    .b(b)
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
        #10
        valid = 1;
        x = 11'b00101100101;
        y = 10'b0010010110;
        read_value = 8'b01100100;
        read_index = 1;
    end
    
    
endmodule
