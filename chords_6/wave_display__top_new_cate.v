module wave_display_top(
    input clk,
    input reset,
    input new_sample,
  input [15:0] sample_all, 
  input [15:0] sample_one, 
  input [15:0] sample_two, 
  input [15:0] sample_three,
    input [10:0] x,  // [0..1279]
    input [9:0]  y,  // [0..1023]     
    input valid,
    input vsync,
    input btn0,
    input btn1,
    input btn2,
    output [7:0] r,
    output [7:0] g,
    output [7:0] b
);

    wire [7:0] read_sample_all, write_sample_all, read_sample_one, write_sample_one, read_sample_two, write_sample_two, read_sample_three, write_sample_three;
    wire [8:0] read_address_all, write_address_all, read_address_one, write_address_one, read_address_two, write_address_two, read_address_three, write_address_three;
    wire read_index;
    wire write_en;
    wire wave_display_idle = ~vsync;

    wave_capture wc_all(
        .clk(clk),
        .reset(reset),
        .new_sample_ready(new_sample),
      .new_sample_in(sample_all),
        .write_address(write_address_all),
        .write_enable(write_en),
        .write_sample(write_sample_all),
        .wave_display_idle(wave_display_idle),
        .read_index(read_index)
    );
  
      wave_capture wc_one(
        .clk(clk),
        .reset(reset),
        .new_sample_ready(new_sample),
        .new_sample_in(sample_one),
          .write_address(write_address_one),
        .write_enable(write_en),
          .write_sample(write_sample_one),
        .wave_display_idle(wave_display_idle),
        .read_index(read_index)
    );
  
      wave_capture wc_two(
        .clk(clk),
        .reset(reset),
        .new_sample_ready(new_sample),
        .new_sample_in(sample_two),
          .write_address(write_address_two),
        .write_enable(write_en),
          .write_sample(write_sample_two),
        .wave_display_idle(wave_display_idle),
        .read_index(read_index)
    );
  
      wave_capture wc_three(
        .clk(clk),
        .reset(reset),
        .new_sample_ready(new_sample),
        .new_sample_in(sample_three),
          .write_address(write_address_three),
        .write_enable(write_en),
          .write_sample(write_sample_three),
        .wave_display_idle(wave_display_idle),
        .read_index(read_index)
    );
  
    
    ram_1w2r #(.WIDTH(8), .DEPTH(9)) sample_ram(
        .clka(clk),
        .clkb(clk),
        .wea(write_en),
        .addra(write_address),
        .dina(write_sample),
        .douta(),
        .addrb(read_address),
        .doutb(read_sample)
    );
    
    wire [10:0] start_x,end_x;
    wire [9:0] start_y,end_y;
    wire [2:0] display;
    wire sample_num; 
    
    wf_limits wf_limits_wd_top (
        .clk(clk),
        .rst(reset),
        .btn0(btn0),
        .btn1(btn1),
        .btn2(btn2),
        .start_x(start_x),
        .end_x(end_x),
        .start_y(start_y),
        .end_y(end_y),
        .display(display)
);
    
 
    wire valid_pixel;
    wire [7:0] wd_r, wd_g, wd_b;
    wave_display wd_all(
        .clk(clk),
        .reset(reset),
        .x(x),
        .y(y),
        .valid(valid),
      .read_address(read_address_all),
      .read_value(read_sample_all),
        .read_index(read_index),
        .start_x(start_x),
        .end_x(end_x),
        .start_y(start_y),
        .end_y(end_y),
        .display(display),
        .valid_pixel(valid_pixel),
        .r(wd_r), .g(wd_g), .b(wd_b)
    );
  
      wave_display wd_one(
        .clk(clk),
        .reset(reset),
        .x(x),
        .y(y),
        .valid(valid),
        .read_address(read_address_one),
        .read_value(read_sample_one),
        .read_index(read_index),
        .start_x(start_x),
        .end_x(end_x),
        .start_y(start_y),
        .end_y(end_y),
        .display(display),
        .valid_pixel(valid_pixel),
        .r(wd_r), .g(wd_g), .b(wd_b)
    );
  
      wave_display wd_two(
        .clk(clk),
        .reset(reset),
        .x(x),
        .y(y),
        .valid(valid),
        .read_address(read_address_two),
        .read_value(read_sample_two),
        .read_index(read_index),
        .start_x(start_x),
        .end_x(end_x),
        .start_y(start_y),
        .end_y(end_y),
        .display(display),
        .valid_pixel(valid_pixel),
        .r(wd_r), .g(wd_g), .b(wd_b)
    );
  
      wave_display wd_three(
        .clk(clk),
        .reset(reset),
        .x(x),
        .y(y),
        .valid(valid),
        .read_address(read_address_three),
        .read_value(read_sample_three),
        .read_index(read_index),
        .start_x(start_x),
        .end_x(end_x),
        .start_y(start_y),
        .end_y(end_y),
        .display(display),
        .valid_pixel(valid_pixel),
        .r(wd_r), .g(wd_g), .b(wd_b)
    );

    assign {r, g, b} = valid_pixel ? {wd_r, wd_g, wd_b} : {3{8'b0}};

endmodule
