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
    
    always @(*) begin
        case(x[10:8])
            3'b000: read_address = 0;
            3'b001: read_address = {read_ind, 0, x[7:1]};
            3'b010: read_address = {read_ind, 1, x[7:1]};
            3'b011: read_address = 0;
            default: read_adress = 0;
        endcase
    end
    
    wire y_top [9:0] = {0, y[8:1]};
    
    wire [7:0] prev_read_value;
    dffr #(8) RAM_dff (.clk(clk), .r(reset), .d(read_value), .q(prev_read_value));
            
    
    
endmodule
