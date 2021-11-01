module wave_display (
    input clk,
    input reset,
    input [10:0] x,  // [0..1279]
    input [9:0]  y,  // [0..1023]
    input valid,
    input [7:0] read_value,
    input read_index,
    output reg [8:0] read_address,
    output wire valid_pixel,
    output wire [7:0] r,
    output wire [7:0] g,
    output wire [7:0] b
);
    
    reg valid_x;
    
    always @(*) begin
        case(x[10:8])
            3'b000: begin 
                read_address = 0;
                valid_x = 0;
            end
            3'b001: begin
                read_address = {read_index, 1'b0, x[7:1]};
                valid_x = 1;
            end
            3'b010: begin
                read_address = {read_index, 1'b1, x[7:1]};
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
    
    wire [7:0] prev_read_value;
    dffr #(8) RAM_dff (.clk(clk), .r(reset), .d(read_value), .q(prev_read_value));
    
    wire [9:0] y_top = {1'b0, y[8:1]};  //y in top half
    
    wire magn_valid, magn_valid1, magn_valid2;
    
    assign magn_valid1 = ((read_value > y_top[8:1]) && (y_top[8:1] > prev_read_value));
    assign magn_valid2 = ((read_value < y_top[8:1]) && (y_top[8:1] < prev_read_value));
    assign magn_valid = (magn_valid1 || magn_valid2);     //high if between RAM[x] and RAM[x-1]
    
   
    assign {r,g,b} = (magn_valid)? 24'h0000f0 : 24'hffffff;
            
   
endmodule
