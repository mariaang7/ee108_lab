module shifter #(parameter FLASH=0) (
    input wire shift_left, shift_right,
    input clk,
    input rst,
    output reg [8:0] out
);

reg [3:0] blink_rate_new;
wire [3:0] blink_rate;
wire [1:0] shift = {shift_left, shift_right};


//shift_left = slower
//shift_right = faster

dff #(4) flash (.clk(clk), .d(blink_rate_new), .q(blink_rate));


always @(*) begin
    case(blink_rate)
        4'b0001: blink_rate_new = (shift == 01 || shift == 00 || shift == 11) ? 4'b0001 : 4'b0010;
        4'b0010: blink_rate_new = (shift == 00 || shift == 11) ? 4'b0010 : ((shift == 01) ? 4'b0100 : 4'b0001);
        4'b0100: blink_rate_new = (shift == 00 || shift == 11) ? 4'b0100 : ((shift == 01) ? 4'b1000 : 4'b0010);
        4'b1000: blink_rate_new = (shift == 10 || shift == 00 || shift == 11) ? 4'b1000 : 4'b0100;
        default: blink_rate_new = (FLASH == 0)? 4'b0001 : 4'b1000;
     endcase
 end
 
always @(*) begin
    if (rst) begin
      blink_rate_new = (FLASH == 0)? 4'b0001 : 4'b1000;
      end 
    else begin 
      blink_rate_new = blink_rate_new;
      end 
      end
    

always @(*) begin
    if (FLASH == 0)
        out = {blink_rate , 5'b00000};
    else if (FLASH == 1)
        out =  {3'b000, blink_rate, 2'b00};
end

endmodule
