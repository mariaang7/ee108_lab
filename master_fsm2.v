module master_fsm (input wire next,
                   input wire slower,
                   input wire faster,
                   output wire [2:0] state,
                   output reg shift_left_1,
                   output reg shift_left_2,
                   output reg shift_right_1,
                   output reg shift_right_2,
                   input wire clock,
                   input wire reset
);
  
  reg [2:0] next_state1;
  wire [2:0] next_state;
  
  dffr #(3) master_flip(.clk(clock), .r(reset), .d(next_state), .q(state));  
                     
  always @(*) begin
    case (state) 
      3'b000: next_state1 = next ? 3'b001 : 3'b000;
      3'b001: next_state1 = next ? 3'b010 : 3'b001;
      3'b010: next_state1 = next ? 3'b011 : 3'b010;
      3'b011: next_state1 = next ? 3'b100 : 3'b011;
      3'b100: next_state1 = next ? 3'b101 : 3'b100;
      3'b101: next_state1 = next ? 3'b000 : 3'b101;
      default: next_state1 = 3'b000;
    endcase 
  end
  
  assign next_state = reset ? 3'b000 : next_state1;
  
  always @(*) begin
    if (state == 3'b011) begin
      shift_right_1 = slower;
      shift_left_1 = faster;
      shift_right_2 = 3'b000;
      shift_left_2 = 3'b000;
      end
    else if (state == 3'b101) begin
      shift_right_1 = 3'b000;
      shift_left_1 = 3'b000;
      shift_right_2 = slower;
      shift_left_2 = faster;
      end
    else begin
      shift_right_1 = 3'b000;
      shift_left_1 = 3'b000;
      shift_right_2 = 3'b000;
      shift_left_2 = 3'b000;
      end
  end 
 
endmodule
