module sine_reader(
    input clk,
    input reset,
    input [19:0] step_size,
    input generate_next,
    input rewind,

    output sample_ready,
    output wire [15:0] sample
);

    //states
    localparam SWIDTH = 22;

    wire [SWIDTH - 1:0] addr;
    wire [SWIDTH - 1:0] new_addr;
    
    assign new_addr = rewind ? addr - step_size : addr + step_size;
    
    dffre #(.WIDTH(SWIDTH)) state_reg (
        .clk(clk),
        .r(reset),
        .en(generate_next),
        .d(new_addr),
        .q(addr)
    );

    wire [9:0] sine_rom_addr = addr[20] ? ~addr[19:10] : addr[19:10];
    wire [15:0] sine_rom_out;
    sine_rom sineRom (
        .clk(clk),
        .addr(sine_rom_addr),
        .dout(sine_rom_out)
    );
    assign sample = addr[21] ? -sine_rom_out : sine_rom_out;

    wire almost_ready;
    dff #(.WIDTH(1)) ready_1 (
        .clk(clk),
        .d(generate_next),
        .q(almost_ready)
    );
    dff #(.WIDTH(1)) ready_2 (
        .clk(clk),
        .d(almost_ready),
        .q(sample_ready)
    );

endmodule