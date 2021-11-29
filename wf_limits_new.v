module wf_limits(
  input btn1,
  input btn2,
  input btn3,
  input clk,
  input rst,
  output reg [9:0] start_x,
  output reg [9:0] end_x,
  output reg [9:0] start_y,
  output reg [9:0] end_y
);
  
  `define DEFAULT_DISPLAY 3'b000
  `define FULL_SCREEN 3'b001
  `define STAGE1 3'b010
  `define STAGE2 3'b011
  `define STAGE3 3'b100
  `define STAGE4 3'b101
  
  
  wire [9:0] default_start_x, default_end_x, default_start_y, default_end_y;
  wire [9:0] max_start_x, max_end_x, max_start_y, max_end_y;
    
  //new default display
  assign default_start_x  = 10'd138;
  assign default_end_x = 10'd838;
  assign default_start_y = 10'd62;
  assign default_end_y = 10'd482;
  
  //max display
  assign max_start_x = 10'd88;
  assign max_end_x = 10'd888;
  assign max_start_y = 10'd32;
  assign max_end_y = 10'd512;
 
  reg [9:0] next_start_x, next_end_x, next_start_y, next_end_y;
  wire [9:0] start_x, end_x, start_y, end_y;
  
  reg [2:0] next_state;
  wire [2:0] state;
  
  dffr #(3) states(.clk(clk), .r(rst), .d(next_state), .q(state));
  
  dffr #(10) display_start_x(.clk(clk), .r(rst), .d(next_start_x), .q(start_x));
  dffr #(10) display_end_x(.clk(clk), .r(rst), .d(next_end_x), .q(end_x));
  dffr #(10) display_start_y(.clk(clk), .r(rst), .d(next_start_y), .q(start_y));
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
        next_state = ({btn1, btn2, btn3} == 3'b100) ? `FULL_SCREEN : 
        (({btn1, btn2, btn3} == 3'b010) ? `STAGE1 :  `DEFAULT_DISPLAY);
        next_start_x = default_start_x;
        next_end_x = default_end_x;
        next_start_y = default_start_y;
        next_end_y = default_end_y;
      end
      4'b0001: begin   //Full screen
        next_state = ({btn1, btn2, btn3} == 3'b001) ? `DEFAULT_DISPLAY : (({btn1, btn2, btn3} == 3'b001) ? `STAGE4 : `FULL_SCREEN);
        next_start_x = max_start_x;
        next_end_x = max_end_x;
        next_start_y = max_start_y;
        next_end_y =  max_end_y;
      end
      4'b0010: begin   //Stage 1
        next_state = ({btn1, btn2, btn3} == 3'b010) ? `STAGE2 : (({btn1, btn2, btn3} == 3'b100 || {btn1, btn2, btn3} == 3'b001) ? `DEFAULT_DISPLAY : `STAGE1);
        next_start_x = start_x - 10'd10;;
        next_end_x = end_x + 10'd10;
        next_start_y = start_y - 10'd6;;
        next_end_y = end_y + 10'd6;
      end
      4'b0011: begin   //Stage 2
        next_state = ({btn1, btn2, btn3} == 3'b010) ? `STAGE3 : (({btn1, btn2, btn3} == 3'b001) ? `STAGE1 : (({btn1, btn2, btn3} == 3'b100) ?`DEFAULT_DISPLAY : `STAGE2));
        next_start_x = start_x - 2*10'd10;;
        next_end_x = end_x + 2*10'd10;
        next_start_y = start_y - 2*10'd6;;
        next_end_y = end_y + 2*10'd6;
      end
      4'b0100: begin    //Stage 3
        next_state = ({btn1, btn2, btn3} == 3'b010) ? `STAGE4 : (({btn1, btn2, btn3} == 3'b001) ? `STAGE2 : (({btn1, btn2, btn3} == 3'b100) ?`DEFAULT_DISPLAY : `STAGE3));
        next_start_x = start_x - 3*10'd10;;
        next_end_x = end_x + 3*10'd10;
        next_start_y = start_y - 4*10'd6;;
        next_end_y = end_y + 4*10'd6;
      end
      4'b0101: begin   //Stage 4
        next_state = ({btn1, btn2, btn3} == 3'b010) ? `FULL_SCREEN : (({btn1, btn2, btn3} == 3'b001) ? `STAGE3 : (({btn1, btn2, btn3} == 3'b100) ?`DEFAULT_DISPLAY : `STAGE4));
        next_start_x = start_x - 5*10'd10;;
        next_end_x = end_x + 5*10'd10;
        next_start_y = start_y - 5*10'd6;;
        next_end_y = end_y + 5*10'd6;
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
endmodule
