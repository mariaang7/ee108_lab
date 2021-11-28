module wf_display_limits (
  input btn1,
  input btn2,
  input btn3,
  input clk,
  input rst,
  output reg [9:0] start_x,
  output reg [9:0] end_x,
  output reg [9:0] start_y,
  output reg [9:0] end_y,
)
  
  `define DEFAULT_DISPLAY 3'b000
  `define MAX_WIDTH 3'b001
  `define FULL_SCREEN 3'b010
  `define MAX_HEIGHT 3'b011
  `define INCREASE_WIDTH 3'b100
  `define DECREASE_WIDTH 3'b101
  `define INCREASE_HEIGHT 3'b110
  `define DECREASE_HEIGHT 3'b111
  
  //new default display
  assign default_start_x = 3'd138;
  assign default_end_x = 3'd838;
  assign default_start_y = 2'd62;
  assign default_end_y = 3'd482;
  
  //max display
  assign max_start_x = 3'd88;
  assign max_end_x = 3'd888;
  assign max_start_y = 2'd32;
  assign max_end_y = 3'd512;
 
  reg [9:0] next_start_x, next_end_x, next_start_y, next_end_y;
  output wire [9:0] start_x, end_x, start_y, end_y;
  
  dffr #(3) states(.clk(clk), .r(rst), .d(next_state), .q(state));
  
  dffr #(10) display_start_x(.clk(clk), .r(rst), .d(next_start_x), .q(start_x));
  dffr #(10) display_end_x(.clk(clk), .r(rst), .d(next_end_x), .q(end_x));
  dffr #(10) display_start_y(.clk(clk), .r(rst), .d(next_end_y), .q(start_y));
  dffr #(10) display_end_y(.clk(clk), .r(rst), .d(next_end_y), .q(end_y));
  
  always @(*) begin
    casex({rst, state})
      4'b1xxx: begin
        next_state = `DEFAULT_DISPLAY;
        next_start_x = default_start_x;
        next_end_x = default_end_x;
        next_start_y = default_start_y;
        next_end_y = default_end_y;
      end
      4'b0000: begin    //Default display
        next_state = ({btn1, btn2, btn3} == 100) ? `MAX_WIDTH : 
          (({btn1, btn2, btn3} == 010) ? `INCREASE_WIDTH : 
           (({btn1, btn2, btn3} == 001) ? `INCREASE_HEIGHT : `DEFAULT_DISPLAY));
        next_start_x = default_start_x;
        next_end_x = default_end_x;
        next_start_y = default_start_y;
        next_end_y = default_end_y;
      end
      4'b0001: begin   //Max width
        next_state = ({btn1, btn2, btn3} == 100) ? `FULL_SCREEN : `MAX_WIDTH;
        next_start_x = max_start_x;
        next_end_x = max_end_x;
        next_start_y = default_start_y;
        next_end_y = default_end_y;
      end
      4'b0010: begin   //Full screen
        next_state = ({btn1, btn2, btn3} == 100) ? `MAX_HEIGHT : `FULL_SCREEN;
        next_start_x = max_start_x;
        next_end_x = max_end_x;
        next_start_y = max_start_y;
        next_end_y = max_end_y;
      end
      4'b0011: begin    //Max height
        next_state = ({btn1, btn2, btn3} == 100) ? `DEFAULT_DISPLAY : `MAX_HEIGHT
        next_start_x = default_start_x;
        next_end_x = default_end_x;
        next_start_y = max_start_y;
        next_end_y = max_end_y;
      end
      4'b0100: begin   //Increase width
        next_state = ({btn1, btn2, btn3} == 100) ? `DEFAULT_DISPLAY : 
        ((({btn1, btn2, btn3} == 010) && start_x > max_start_x && end_x < max_end_x) ? `INCREASE_WIDTH : 
         ((({btn1, btn2, btn3} == 010) && start_x == max_start_x && end_x == max_end_x) ? `DECREASE_WIDTH : `INCREASE_WIDTH));
        next_start_x = start_x - 2'd20;
        next_end_x = end_x + 2'd20;
        next_start_y = start_y;
        next_end_y = end_y;
      end
      4'b0101: begin    //Decrease width
        next_state = ({btn1, btn2, btn3} == 100) ? `DEFAULT_DISPLAY : 
        ((({btn1, btn2, btn3} == 010) && start_x < default_start_x && end_x > default_end_x) ? `DECREASE_WIDTH : 
         ((({btn1, btn2, btn3} == 010) && start_x == default_start_x && end_x == default_end_x) ? `INCREASE_WIDTH : `DECREASE_WIDTH));
        next_start_x = start_x + 2'd20;
        next_end_x = end_x - 2'd20;
        next_start_y = start_y;
        next_end_y = end_y;
      end
      4'b0110: begin    //Increase height
        next_state = ({btn1, btn2, btn3} == 100) ? `DEFAULT_DISPLAY : 
        ((({btn1, btn2, btn3} == 001) && start_y > max_start_y && end_y < max_end_y) ? `INCREASE_HEIGHT : 
         ((({btn1, btn2, btn3} == 001) && start_y == max_start_y && end_y == max_end_y) ? `DECREASE_HEIGHT : `INCREASE_HEIGHT));
        next_start_x = start_x;
        next_end_x = end_x;
        next_start_y = start_y - 2'd12;
        next_end_y = end_y + 2'd12;
      end
      4'b0111: begin    //Decrease height
        next_state = ({btn1, btn2, btn3} == 100) ? `DEFAULT_DISPLAY : 
        ((({btn1, btn2, btn3} == 001) && start_y < default_start_y && end_y > default_end_y) ? `DECREASE_HEIGHT : 
         ((({btn1, btn2, btn3} == 001) && start_y == default_start_y && end_y == default_end_y) ? `INCREASE_HEIGHT : `DECREASE_HEIGHT));
        next_start_x = start_x;
        next_end_x = end_x;
        next_start_y = start_y + 2'd12;
        next_end_y = end_y - 2'd12;
      end
      default: begin
        next_state = `DEFAULT_DISPLAY;
        next_start_x = default_start_x;
        next_end_x = default_end_x;
        next_start_y = default_start_y;
        next_end_y = default_end_y;
      end
    endcase
  end
  
      
        
  
