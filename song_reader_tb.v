module song_reader_tb();

    reg clk, reset, play, note_done, rewind, ff;
    reg [1:0] song;
    wire song_done;
    wire [5:0] note;
    wire [5:0] duration;
    wire new_note;


    
    song_reader dut (
    .clk(clk),
    .reset(reset),
    .play(play),
    .song(song),
    .rewind(rewind),
    .ff(ff),
    .new_note(new_note),
    .note(note),
    .duration(duration),
    .note_done(note_done),
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

    initial begin
        note_done = 1'b0;
        forever #20 note_done = ~note_done;
    end 
    
    // Tests
    initial begin
        play = 1'b0;
        rewind = 1'b0;
        ff = 1'b0;
        #50
        play = 1'b1;
        #50
        song = 1'b1;
        #500;
        rewind = 1'b1;
        #200
        rewind = 1'b0;
        #500
        ff = 1'b1;
        #100
        ff = 1'b0;
        
        
    end

endmodule
