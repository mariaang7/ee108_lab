module song_reader_tb();

    reg clk, reset, play, note_done;
    reg [1:0] song;
    wire song_done;
    wire [5:0] note_one, note_two, note_three;
    wire [5:0] duration_one, duration_two, duration_three;
    wire new_note_one, new_note_two, new_note_three;
/*    wire advance_done;
    wire [5:0] advance_duration;*/
    wire beat;
    reg note_one_done, note_two_done, note_three_done;
    
    //beat_generator beat_song_reader (.clk(clk), .reset(reset), .en(), .beat(beat));

    song_reader dut (
    .clk(clk),
    .reset(reset),
    .play(play),
    .song(song),
    .note_one_done(note_one_done),
    .note_two_done(note_two_done),
    .note_three_done(note_three_done),
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
    
    initial begin
        note_one_done = 1'b0;
        note_two_done = 1'b0;
        note_three_done = 1'b0;
        forever #50 note_one_done = ~note_one_done;
    end
    initial begin
        forever #100 note_two_done = ~note_two_done;
    end
    initial begin
        forever #150 note_three_done = ~note_three_done;
    end

    // Tests
    initial begin
        play = 1'b1;
        song = 1'b0;
        #500;
    end

endmodule
