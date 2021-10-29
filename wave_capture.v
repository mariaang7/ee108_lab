module wave_capture (
    input clk,
    input reset,
    input new_sample_ready,
    input [15:0] new_sample_in,
    input wave_display_idle,

    output wire [8:0] write_address,
    output wire write_enable,
    output wire [7:0] write_sample,
    output wire read_index
);
    `define STATE_ARMED 2'b00
    `define STATE_ACTIVE 2'b01
    `define STATE_WAIT 2'b10
    
    
    reg [1:0] next_state;
    wire [1:0] state;
    wire [7:0] count;
    reg [7:0] next_count;
    
    
    dffr #(2) states(.clk(clk), .r(reset), .d(next_state), .q(state));
    dffr #(2) counter(.clk(clk), .r(reset), .d(next_count), .q(count));
    
    
    always @(*) begin
        case(state)
            2'b00: begin
                next_state = (new_sample_in >= 0) ? 2'b01 : 2'b00;
            end 
            2'b01: begin
            end 
            2'b10: begin
            end 
        default: next_state = 2'b00;
        endcase 
    end 
    
    
endmodule
