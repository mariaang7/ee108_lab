module sine_reader(
    input clk,
    input reset,
    input [19:0] step_size,
    input generate_next,

    output sample_ready,
    output wire [15:0] sample
);

    wire [15:0] out;
    
    reg [21:0] next_address;
    wire [21:0] address;
    dffr #(22) counter (.clk(clk), .r(reset), .d(next_address), .q(address));
    
    wire [9:0] address_sine; 
    sine_rom sines(.clk(clk), .addr(address_sine), .dout(out));
    
    always @(*) begin 
        case (generate_next)
            1'b1: next_address = address + step_size;
            default: next_address = address;
        endcase
    end 
    
    wire [1:0] Q = address[21:20];
    reg [9:0] raw_address;
    
    always @(*) begin
        casex (Q)
            2'bx0: raw_address = address[19:10];
            2'bx1: raw_address = 10'b0 - address[19:10];
            default: raw_address = address[19:10];
        endcase
    end
    
    always @(*) begin
        case (quad_count)
            2'b00: address_sine = raw_address;
                   next_quad_count = 2'b01;
            2'b01: address_sine = raw_address;
                   next_quad_count = 2'b10;
            2'b10: address_sine = 10'b0 - raw_address;
                   next_quad_count = 2'b10;
            2'b10: address_sine = 10'b0 - raw_address;
                   next_quad_count = 2'b00;
            default: address_sine = raw_address;
                     next_quad_count = 2'b01;
        endcase
    end
    
    reg [1:0] next_quad_count;
    wire [1:0] quad_count;
    dff #(2) quadrant_count (.clk(clk), .d(next_quad_count), .q(quad_count));
    
    assign sample = (Q == 00 || Q == 01) ? out : 15'b0 - out;
    
    sample_ready???
   

endmodule
