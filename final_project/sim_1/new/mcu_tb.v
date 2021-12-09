module mcu_tb();
    reg clk, reset, play_button, next_button, rewind_button, ff_button, song_done;
    wire play, reset_player, rewind, ff;
    wire [1:0] song;

    mcu dut(
        .clk(clk),
        .reset(reset),
        .play_button(play_button),
        .next_button(next_button),
        .rewind_button(rewind_button),
        .ff_button(ff_button),
        .play(play),
        .reset_player(reset_player),
        .rewind(rewind),
        .ff(ff),
        .song(song),
        .song_done(song_done)
    );

    // Clock and reset
    initial begin
        clk = 1'b0;
        reset = 1'b1;
        repeat (4) #5 clk = ~clk;
        reset = 1'b0;
        forever #5 clk = ~clk;
    end

    // Tests
    initial begin
        next_button = 1'b0;
        play_button = 1'b0;
        rewind_button = 1'b0;
        ff_button = 1'b0;
        song_done = 1'b0;
        #100
        play_button = 1'b1;
        #10
        play_button = 1'b0;
        #200
        rewind_button = 1'b1;
        #10
        rewind_button = 1'b0;
        #100
        play_button = 1'b1;
        #10
        play_button = 1'b0;
        #100
        play_button = 1'b1;
        #10
        play_button = 1'b0;
        #100
        ff_button = 1'b1;
        #10
        ff_button = 1'b0;
        #100
        play_button = 1'b1;
        #10
        play_button = 1'b0;
        #100
        
        
        ;  
    end

endmodule
