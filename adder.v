module adder (
    input wire [4:0] a,
    input wire [4:0] b,
    output wire [4:0] sum,
    output reg cout
);

wire [6:0] result;
wire [4:0] actual;
assign result = a + b;
assign sum = a + b;
always @(*) begin
    if (result != sum) begin
        cout = 1'b1;
    end else begin
        cout = 1'b0;
    end
end 
    
endmodule
