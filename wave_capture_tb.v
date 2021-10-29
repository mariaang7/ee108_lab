module wave_capture_tb ();

reg clk, reset, new_sample_ready, wave_display_idle;
reg [15:0] new_sample_in;
wire [8:0] write_address;
wire write_enable;
wire [7:0] write_sample;
wire read_index;

wave_capture dut(
    .clk(clk), 
    .reset(reset), 
    .new_sample_ready(new_sample_ready), 
    .new_sample_in(new_sample_in), 
    .wave_display_idle(wave_display_idle), 
    .write_address(write_address),
    .write_enable(write_enable), 
    .write_sample(write_sample),
    .read_index(read_index)
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
        new_sample_in = 16'b1111111111111111;
        new_sample_ready = 1'b1;
        #20
        new_sample_ready = 1'b0;
        #20
        wave_display_idle = 1'b1;
        #20
        wave_display_idle = 1'b0; 
    end

endmodule
