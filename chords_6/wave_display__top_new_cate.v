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
    output reg [7:0] r,
    output reg [7:0] g,
    output reg [7:0] b
);

    wire [7:0] read_sample_all, write_sample_all, read_sample_one, write_sample_one, read_sample_two, write_sample_two, read_sample_three, write_sample_three;
    wire [8:0] read_address_all, write_address_all, read_address_one, write_address_one, read_address_two, write_address_two, read_address_three, write_address_three;
    wire read_index;
    wire write_en_one, write_en_two, write_en_three, write_en_all;
    wire wave_display_idle = ~vsync;

    wave_capture wc_all(
        .clk(clk),
        .reset(reset),
        .new_sample_ready(new_sample),
      .new_sample_in(sample_all),
        .write_address(write_address_all),
        .write_enable(write_en_all),
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
        .write_enable(write_en_one),
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
        .write_enable(write_en_two),
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
        .write_enable(write_en_three),
          .write_sample(write_sample_three),
        .wave_display_idle(wave_display_idle),
        .read_index(read_index)
    );
  
    
    ram_1w2r #(.WIDTH(8), .DEPTH(9)) sample_ram1(
        .clka(clk),
        .clkb(clk),
        .wea(write_en_one),
        .addra(write_address_one),
        .dina(write_sample_one),
        .douta(),
        .addrb(read_address_one),
        .doutb(read_sample_one)
    );
    
    ram_1w2r #(.WIDTH(8), .DEPTH(9)) sample_ram2(
        .clka(clk),
        .clkb(clk),
        .wea(write_en_two),//////////
        .addra(write_address_two),
        .dina(write_sample_two),
        .douta(),
        .addrb(read_address_two),
        .doutb(read_sample_two)
    );
    
    ram_1w2r #(.WIDTH(8), .DEPTH(9)) sample_ram3(
        .clka(clk),
        .clkb(clk),
        .wea(write_en_three),
        .addra(write_address_three),
        .dina(write_sample_three),
        .douta(),
        .addrb(read_address_three),
        .doutb(read_sample_three)
    );
    
    ram_1w2r #(.WIDTH(8), .DEPTH(9)) sample_ram4(
        .clka(clk),
        .clkb(clk),
        .wea(write_en_all),
        .addra(write_address_all),
        .dina(write_sample_all),
        .douta(),
        .addrb(read_address_all),
        .doutb(read_sample_all)
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
    wire y_size;
    wire screen_quarter;
    assign screen_quarter = y_size >> 2;
    wire [7:0] r_one, r_two, r_three, r_all, g_one, g_two, g_three, g_all, b_one, b_two, b_three, b_all;
    wire valid_pixel_all, valid_pixel_one, valid_pixel_two, valid_pixel_three;
    wire [9:0] start_y_one, start_y_two, start_y_three, start_y_all, end_y_one, end_y_two, end_y_three, end_y_all;
    assign {start_y_one, end_y_one} = {start_y, (start_y + screen_quarter)};
    assign {start_y_two, end_y_two} = {start_y, (end_y_one +  (2 * screen_quarter))};
    assign {start_y_three, end_y_three} = {start_y, (end_y_two + (3 * screen_quarter))};
    assign {start_y_all, end_y_all} = {start_y, (end_y_three + end_y)};
    reg [7:0] red, green, blue;
    
    
    //wire [7:0] wd_r, wd_g, wd_b;
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
        .num(3'd4),
        .start_y(start_y_all),
        .end_y(end_y_all),
        .display(display),
        .valid_pixel(valid_pixel_all),
        .r(r_all), .g(g_all), .b(b_all)
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
        .num(3'd1),
          .start_y(start_y_one),
          .end_y(end_y_one),
        .display(display),
        .valid_pixel(valid_pixel_one),
          .r(r_one), .g(g_one), .b(b_one)
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
        .num(3'd2),
          .start_y(start_y_two),
          .end_y(end_y_two),
        .display(display),
        .valid_pixel(valid_pixel_two),
          .r(r_two), .g(g_two), .b(b_two)
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
        .num(3'd3),
          .start_y(start_y_three),
          .end_y(end_y_three),
        .display(display),
        .valid_pixel(valid_pixel_three),
          .r(r_three), .g(g_three), .b(b_three)
    );
    
    always @(*) begin
        if (x > start_x && x < end_x && y > start_y_one && y < end_y_one) begin
            {red, green, blue} = {r_one, g_one, b_one};
            {r, g, b} = valid_pixel_one ? {red, green, blue} : 24'h000000;
        end else if (x > start_x && x < end_x && y > start_y_two && y < end_y_two) begin
            {red, green, blue} = {r_two, g_two, b_two};
            {r, g, b} = valid_pixel_two ? {red, green, blue} : 24'h000000;
        end else if (x > start_x && x < end_x && y > start_y_three && y < end_y_three) begin
            {red, green, blue} = {r_three, g_three, b_three};
            {r, g, b} = valid_pixel_three ? {red, green, blue} : 24'h000000;
        end else if (x > start_x && x < end_x && y > start_y_all && y < end_y_all) begin
            {red, green, blue} = {r_all, g_all, b_all};
            {r, g, b} = valid_pixel_all ? {red, green, blue} : {3{8'b0}};
        end else begin
            {red, green, blue} = 24'h000000;
        end
    end
        

    //assign {r, g, b} = valid_pixel ? {red, green, blue} : {3{8'b0}};

endmodule
