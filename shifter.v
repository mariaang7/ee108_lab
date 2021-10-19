module shifter #(parameter FLASH=1) (
    input wire shift_left, shift_right,
    input clk,
    input rst,
    output reg [9:0] out
);

reg [3:0] blink_rate1;
reg [3:0] blink_rate2;
reg [3:0] blink_rate_new1;
reg [3:0] blink_rate_new2;
reg [3:0] blink_rate_out;

//shift_left = slower
//shift_right = faster

dffr #(4) flash1 (.clk(clk), .r(rst), .d(blink_rate1), .q(blink_rate_new1));

dffr #(4) flash2 (.clk(clk), .r(rst), .d(blink_rate2), .q(blink_rate_new2));

always @(*) begin
    if (FLASH == 1) //1s, 2s, 4s, 8s
        if (shift_left == 1 && shift_right == 0)
            blink_rate_new1 = (blink_rate1 == 4'b1000) ? 4'b1000 : (blink_rate_new1 << 1);
        else if (shift_left == 0 && shift_right == 1)
            blink_rate_new1 = (blink_rate1 == 4'b0001) ? 4'b0001 : (blink_rate_new1 >> 1);
        else if (rst)
            blink_rate_new1 = 4'b1000;
        else 
            blink_rate_new1 = blink_rate1;
        
    else if (FLASH == 2) //1s, 1/2s, 1/4s, 1/8s
        if (shift_left == 1 && shift_right == 0)
            blink_rate_new2 = (blink_rate2 == 4'b0001) ? 4'b0001 : (blink_rate_new2 >> 1);
        else if (shift_left == 0 && shift_right == 1)
            blink_rate_new2 = (blink_rate2 == 4'b1000) ? 4'b1000 : (blink_rate_new2 << 1);
        else if (rst)
            blink_rate_new1 = 4'b1000;
        else 
            blink_rate_new2 = blink_rate2;
end

always @(*) begin
    if (FLASH == 1)
        blink_rate_out = blink_rate_new1;
    else if (FLASH == 2)
        blink_rate_out = blink_rate_new2;
end

always @(*) begin
    case(blink_rate_out)
        4'b1000: out = 10'b000100000; //1s
        4'b0100: out = (FLASH == 1) ? 10'b001000000 : 10'b000010000; //2s : 1/2s
        4'b0010: out = (FLASH == 1) ? 10'b010000000 : 10'b000001000; //4s : 1/4s
        4'b0001: out = (FLASH == 1) ? 10'b100000000 : 10'b000000100; //8s : 1/8s
    endcase

end
          
