`define LOAD_DURATION 2'b00
`define COUNT_DOWN 2'b01
`define WAIT_STATE 2'b10
`define DONE_STATE 2'b11

module time_advancer (
    input clk,
    input reset,
    input [5:0] duration,
    input load_duration,
    input beat,
    output advance_done
);

    wire [1:0] state;
    reg [1:0] next_state;    
    wire [5:0] count; 
    reg [5:0] next_count;
   
    dffr #(.WIDTH(6)) state_reg (
        .clk(clk),
        .r(reset),
        .d(next_state),
        .q(state)
    );
    
    dffr #(.WIDTH(6)) count_reg (
        .clk(clk),
        .r(reset),
        .d(next_count),
        .q(count)
    );

    always @(*) begin
        case(state) 
            `WAIT_STATE: begin
                next_state = load_duration ? `WAIT_STATE : `LOAD_DURATION;
                next_count = 2'b0;
            end
            `COUNT_DOWN: begin
                next_state = (count == 0) ? `DONE_STATE : `COUNT_DOWN;
                next_count = (beat) ? count - 1'b1 : count;
            end 
            `LOAD_DURATION: begin
                next_state = `COUNT_DOWN;
                next_count = duration;
            end 
            `DONE_STATE: begin
                next_state = `WAIT_STATE;
                next_count = count;
            end
        default: begin 
            next_state = `WAIT_STATE;
            next_count = 2'b0;
        end
        endcase
    end
    
    assign advance_done = (state == `DONE_STATE) ? 1'b1 : 1'b0;
endmodule
