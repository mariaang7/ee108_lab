

module chord_player(
    input clk,
    input reset,
    input play,
    input [1:0] song,
    //input rewind, idk what to do with this
    //input ff, idk what to do with this
    input beat,
    output wire song_done,
    output wire [15:0] sample_out
);
    
    wire sample_one_ready, sample_two_ready, sample_three_ready;
    wire [15:0] sample_one, sample_two, sample_three;
    wire done_with_note_one, done_with_note_two, done_with_note_three;
    wire [5:0] note_one, note_two, note_three;
    wire [5:0] duration_one, duration_two, duration_three;
    wire new_note_one, new_note_two, new_note_three;
    wire advance_done;
    wire [5:0] advance_duration;
    
    song_reader chords (
    .clk(clk),
    .reset(reset),
    .play(play),
    .song(song),
    .advance_done(advance_done)
    .advance_duration(advance_duration)
    .note_one_done(done_with_note_one),
    .note_two_done(done_with_note_two),
    .note_three_done(done_with_note_three),
    .rewind(????),
    .ff(????),
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
    .new_note_three(new_note_three),
    );
    
    note_player note_player_one (.clk(clk), .reset(reset), .play_enable(play), .note_to_load(note_one), .duration_to_load(duration_one), 
                                 .load_new_note(new_note_one), .rewind(????), .done_with_note(done_with_note_one), .beat(beat), .generate_next_sample(???),
                                 .sample_out(sample_one), .new_sample_ready(sample_one_ready)
    );
    
    note_player note_player_two (.clk(clk), .reset(reset), .play_enable(play), .note_to_load(note_two), .duration_to_load(duration_two), 
                                 .load_new_note(new_note_two), .rewind(????), .done_with_note(done_with_note_two), .beat(beat), .generate_next_sample(???),
                                 .sample_out(sample_two), .new_sample_ready(sample_two_ready)
    );
    
    note_player note_player_three (.clk(clk), .reset(reset), .play_enable(play), .note_to_load(note_three), .duration_to_load(duration_three), 
                                 .load_new_note(new_note_three), .rewind(????), .done_with_note(done_with_note_three), .beat(beat), .generate_next_sample(???),
                                 .sample_out(sample_three), .new_sample_ready(sample_three_ready)
    );
    
    time_advancer advance (.clk(clk), .reset(reset), .duration(advance_duration), .beat(beat), .advance_done(advance_done));
    
    
    
endmodule
