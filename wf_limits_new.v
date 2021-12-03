
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
  `define MAX_WIDTH 3'b001
  `define FULL_SCREEN 3'b010
  `define MAX_HEIGHT 3'b011
  `define STAGE1 3'b100
  `define STAGE2 3'b101
  `define STAGE3 3'b110
  `define STAGE4 3'b111
  
  
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
 

  
  reg [2:0] next_state;
  wire [2:0] state;
  
  dffr #(3) states(.clk(clk), .r(rst), .d(next_state), .q(state));
  
  
  always @(*) begin
    casex({rst, state})
      4'b1xxx: begin     //Reset
        next_state = `DEFAULT_DISPLAY;
        start_x = default_start_x;
        end_x = default_end_x;
        start_y = default_start_y;
        end_y = default_end_y;
      end
      4'b0000: begin    //Default display
        next_state = ({btn1, btn2, btn3} == 3'b100) ? `MAX_WIDTH : (({btn1, btn2, btn3} == 3'b010) ? `STAGE1 :  `DEFAULT_DISPLAY);
        start_x = default_start_x;
        end_x = default_end_x;
        start_y = default_start_y;
        end_y = default_end_y;
      end
      4'b0001: begin    //Max width
        next_state = ({btn1, btn2, btn3} == 3'b100) ? `FULL_SCREEN : (({btn1, btn2, btn3} == 3'b010) ? `DEFAULT_DISPLAY : `MAX_WIDTH);
        start_x = max_start_x;
        end_x = max_end_x;
        start_y = default_start_y;
        end_y = default_end_y;
      end
      4'b0010: begin   //Full screen
        next_state = ({btn1, btn2, btn3} == 3'b100) ? `MAX_HEIGHT : (({btn1, btn2, btn3} == 3'b010) ? `MAX_WIDTH : (({btn1, btn2, btn3} == 3'b001) ? `STAGE4 : `FULL_SCREEN));
        start_x = max_start_x;
        end_x = max_end_x;
        start_y = max_start_y;
        end_y =  max_end_y;
      end
      4'b0011: begin    //Max heigth
        next_state = ({btn1, btn2, btn3} == 3'b100) ? `DEFAULT_DISPLAY : (({btn1, btn2, btn3} == 3'b010) ? `FULL_SCREEN : `MAX_HEIGHT);
        start_x = default_start_x;
        end_x = default_end_x;
        start_y = max_start_y;
        end_y =  max_end_y;
      end
      4'b0100: begin   //Stage 1
        next_state = ({btn1, btn2, btn3} == 3'b010) ? `STAGE2 : (({btn1, btn2, btn3} == 3'b100 || {btn1, btn2, btn3} == 3'b001) ? `DEFAULT_DISPLAY : `STAGE1);
        start_x = 10'd128;
        end_x = 10'd848;
        start_y = 10'd56;
        end_y = 10'd488;
      end
      4'b0101: begin   //Stage 2
        next_state = ({btn1, btn2, btn3} == 3'b010) ? `STAGE3 : (({btn1, btn2, btn3} == 3'b001) ? `STAGE1 : (({btn1, btn2, btn3} == 3'b100) ? `DEFAULT_DISPLAY : `STAGE2));
        start_x = 10'd118;
        end_x = 10'd858;
        start_y = 10'd50;
        end_y = 10'd494;
      end
      4'b0110: begin    //Stage 3
        next_state = ({btn1, btn2, btn3} == 3'b010) ? `STAGE4 : (({btn1, btn2, btn3} == 3'b001) ? `STAGE2 : (({btn1, btn2, btn3} == 3'b100) ? `DEFAULT_DISPLAY : `STAGE3));
        start_x = 10'd108;
        end_x = 10'd868;
        start_y = 10'd44;
        end_y = 10'd500;
      end
      4'b0111: begin   //Stage 4
        next_state = ({btn1, btn2, btn3} == 3'b010) ? `FULL_SCREEN : (({btn1, btn2, btn3} == 3'b001) ? `STAGE3 : (({btn1, btn2, btn3} == 3'b100) ?`DEFAULT_DISPLAY : `STAGE4));
        start_x = 10'd98;
        end_x = 10'd878;
        start_y = 10'd38;
        end_y = 10'd506;
      end
      default: begin
        next_state = `DEFAULT_DISPLAY;
        start_x = default_start_x;
        end_x = default_end_x;
        start_y = default_start_y;
        end_y = default_end_y;
      end
    endcase
  end
endmodule
