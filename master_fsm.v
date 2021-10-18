module master_fsm (input wire next;
                   input wire slower;
                   input wire faster;
                   output wire [2:0] state;
                   output wire shift_left_1;
                   output wire shift_left_2;
                   output wire shift_right_1;
                   output wire shift_right_2;
                   input clock;
                   input reset;
);
  
  reg [2:0] next_state;
  
  dffr #(3) caterina(.clk(clock), .r(reset), .d(next_state), .q(state));  
                     
  always @(*) begin
    case (state) 
      3'b000: next_state = next ? 3'b001 : 3'b000;
      3'b001: next_state = next ? 3'b010 : 3'b001;
      3'b010: next_state = next ? 3'b011 : 3'b010;
      3'b011: next_state = next ? 3'b100 : 3'b011;
      3'b100: next_state = next ? 3'b101 : 3'b100;
      3'b101: next_state = next ? 3'b000 : 3'b101;
    endcase 
  end
  
  always @(*) begin
    if (state == 3'b011) 
      shift_right_1 = slower;
      shift_left_1 = faster;
    else if (state == 3'b101)
      shift_right_2 = slower;
      shift_left_2 = faster;
    else 
      shift_right_1 = 0;
      shift_right_2 = 0;
      shift_left_1 = 0;
      shift_left_2 = 0;
    endcase 
  end 
  
  assign next_state = reset ? 3'b000 : next_state; 

endmodule
