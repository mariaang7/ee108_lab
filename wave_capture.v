module wave_capture (
    input clk,
    input reset,
    input new_sample_ready,
    input [15:0] new_sample_in,
    input wave_display_idle,

    output wire [8:0] write_address,
    output reg write_enable,
    output wire [7:0] write_sample,
    output reg read_index
);
    
    // need to switch audio sample from signed to unsigned
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
                next_state = (new_sample_in >= 1'b0) ? 2'b01 : 2'b00;
                next_count = 0;
                write_enable = 1'b0;
            end 
            2'b01: begin
                next_state = (count == 8'b11111111) ? 2'b10 : 2'b00;
                next_count = (new_sample_ready) ? count + 1 : count;
            end 
            2'b10: begin
                next_state = wave_display_idle ? 2'b00 : 2'b10;
                //next_count = 0;
                read_index = ~read_index;
                write_enable = 1'b1;
            end 
        default: next_state = 2'b00;
        endcase 
    end 
    
    assign write_address = new_sample_read ? {~read_index, count} : 9'b0;
    assign write_sample = new_sample_in[15:8];
    
endmodule
