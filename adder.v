module adder (
    input wire [4:0] a,
    input wire [4:0] b,
    output wire [4:0] out,
    output reg cout
);

wire [6:0] result;
wire [4:0] actual;
assign result = a + b;
assign actual = a + b;
always @(*) begin
    if (result != actual) begin
        cout = 1'b1;
    end else begin
        cout = 1'b0;
    end
end


endmodule
