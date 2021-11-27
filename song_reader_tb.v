module song_reader_tb();

    reg clk, reset, play, note_done;
    reg [1:0] song;
    wire song_done;
    wire done_with_note_one, done_with_note_two, done_with_note_three;
    wire [5:0] note_one, note_two, note_three;
    wire [5:0] duration_one, duration_two, duration_three;
    wire new_note_one, new_note_two, new_note_three;
    wire advance_done;
    wire [5:0] advance_duration;
    wire beat;
    
    song_reader dut (
    .clk(clk),
    .reset(reset),
    .play(play),
    .song(song),
    .advance_done(advance_done),
    .advance_duration(advance_duration),
    .note_one_done(done_with_note_one),
    .note_two_done(done_with_note_two),
    .note_three_done(done_with_note_three),
    .beat(beat),
    .song_done(song_done),
    .note_one(note_one),
    .note_two(note_two),
    .note_three(note_three),
    .duration_one(duration_one),
    .duration_two(duration_two),
    .duration_three(duration_three),
    .new_note_one(new_note_one),
    .new_note_two(new_note_two),
    .new_note_three(new_note_three)
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
        play = 1'b1;
        song = 1'b1;
        
    end

endmodule


