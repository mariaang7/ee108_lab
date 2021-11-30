module adjustable_wave_display #(parameter WAVE_POSITION) (
    input clk,
    input reset,
    input [10:0] x,  // [0..1279]
    input [9:0]  y,  // [0..1023]
    input valid,
    input [7:0] read_value,
    input read_index,
    input [9:0] start_x, start_y, end_x, end_y;
    output reg [8:0] read_address,
    output wire valid_pixel,
    output wire [7:0] r,
    output wire [7:0] g,
    output wire [7:0] b
);
    
    reg valid_x;
    reg [7:0] read_value_adjusted;
    
    wire [9:0] height;
    assign height = end_y - start_y;
    
    always @(*) begin
        case(WAVE_POSITION)
            2'd0: begin   //note 1
                read_value_adjusted = read_value/12 - (5/12) * height;
            end
            2'd1: begin   //note 2
                read_value_adjusted = read_value/12 - (1/4) * height;
            end
            2'd2: begin   //note 3
                read_value_adjusted = read_value/12 - (1/12) * height;
            end
            2'd3: begin   //chord
                read_value_adjusted = read_value/4 + (1/4) * height;
            end
            default: begin
                read_value_adjusted = (read_value >> 1) + 8'b01000000;
            end
    
    always @(*) begin
        case(x[10:8])
            3'b000: begin 
                read_address = 0;
                valid_x = 0;
            end
            3'b001: begin
                read_address = {read_index, ~x[8], x[7:1]};
                valid_x = 1;
            end
            3'b010: begin
                read_address = {read_index, ~x[8], x[7:1]};
                valid_x = 1;
            end
            3'b011: begin
                read_address = 0;
                valid_x = 0;
            end
            default: begin
                read_address = 0;
                valid_x = 0;
            end
        endcase
    end
    
    assign valid_pixel = (valid_x && ~y[9]);  //if pixel in quadrant 1 or 2
    
    wire [8:0] last_address;
    dffre #(9) addr_dff (.clk(clk), .r(reset), .en(valid), .d(read_address), .q(last_address));
    
    wire en_read = ~(read_address == last_address);
   
    wire [7:0] prev_read_value;
    dffre #(8) RAM_dffre(.clk(clk), .r(reset), .en(en_read), .d(read_value_adjusted), .q(prev_read_value));
    
    
    wire magn_valid, magn_valid1, magn_valid2;
    
    assign magn_valid1 = ((read_value_adjusted >= y[8:1]) && (y[8:1] >= prev_read_value));
    assign magn_valid2 =((read_value_adjusted <= y[8:1]) && (y[8:1] <= prev_read_value));
    assign magn_valid = (magn_valid1 || magn_valid2);     //high if between RAM[x] and RAM[x-1]
    
   
    assign {r,g,b} = (x[9:0] < start_x || y < start_y || x[9:0] > end_x || y > end_y || !magn_valid) ? 24'h000000 : 24'hffffff;
           
   
endmodule
