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
    
    sine_rom sines(.clk(clk), .addr(address[19:10]), .dout(out));
    
    always @(*) begin 
        case (generate_next)
            1'b1: next_address = address + step_size;
            default: next_address = address;
        endcase
    end 
   
            

endmodule
