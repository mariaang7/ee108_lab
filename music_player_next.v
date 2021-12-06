//
//  music_player module
//
//  This music_player module connects up the MCU, song_reader, note_player,
//  beat_generator, and codec_conditioner. It provides an output that indicates
//  a new sample (new_sample_generated) which will be used in lab 5.
//
`define NOTE_ONE 2'b00
`define NOTE_TWO 2'b01
`define NOTE_THREE 2'b10
`define ADVANCE_TIMEE 2'b11


module music_player(
    // Standard system clock and reset
    input clk,
    input reset,

    // Our debounced and one-pulsed button inputs.
    input play_button,
    input next_button,

    // The raw new_frame signal from the ac97_if codec.
    input new_frame,

    // This output must go high for one cycle when a new sample is generated.
    output wire new_sample_generated,

    // Our final output sample to the codec. This needs to be synced to
    // new_frame.
    output wire [15:0] sample_out
);
    // The BEAT_COUNT is parameterized so you can reduce this in simulation.
    // If you reduce this to 100 your simulation will be 10x faster.
    parameter BEAT_COUNT = 1000;


//
//  ****************************************************************************
//      Master Control Unit
//  ****************************************************************************
//   The reset_player output from the MCU is run only to the song_reader because
//   we don't need to reset any state in the note_player. If we do it may make
//   a pop when it resets the output sample.
//
 
    wire play;
    wire reset_player;
    wire [1:0] current_song;
    wire song_done;
    mcu mcu(
        .clk(clk),
        .reset(reset),
        .play_button(play_button),
        .next_button(next_button),
        .play(play),
        .reset_player(reset_player),
        .song(current_song),
        .song_done(song_done)
    );

//
//  ****************************************************************************
//      Song Reader
//  ****************************************************************************
//
    wire [5:0] note_to_play;
    wire [5:0] duration_for_note;
    wire new_note;
    wire note_done;
    song_reader song_reader(
        .clk(clk),
        .reset(reset | reset_player),
        .play(play),
        .song(current_song),
        .song_done(song_done),
        .note(note_to_play),
        .duration(duration_for_note),
        .new_note(new_note),
        .note_done(note_done)
    );

//   
//  ****************************************************************************
//      Note Player
//  ****************************************************************************
//  
    wire beat;
    wire generate_next_sample;
    wire [15:0] note_sample;
    wire note_sample_ready;
  
    wire [1:0] state;
    reg [1:0] next_state;
  
    wire [15:0] sample_one;
    wire [15:0] sample_two;
    wire [15:0] sample_three;
    

  reg  [15:0] note_sample;

  
reg [5:0] note_one, note_two, note_three;
wire [5:0] duration_one, duration_two, duration_three;
  

  dffr #(2) states_fsm (.clk(clk), .r(reset), .d(next_state), .q(state));
  
  always *(@) begin
    case (state) 
      `NOTE_ONE: begin
        next_state = `NOTE_TWO;
        note_one = note_to_play;
        duration_one = duration_for_load;
        note_two = 6'b0;
        duration_two = 6'b0;
        note_three = 6'b0;
        duration_three = 6'b0;
        note_sample = 16'b0;
      end 
      `NOTE_TWO: begin
        next_state = `NOTE_THREE;
        note_two = note_to_play;
        note_one = note_one;
        duration_one = duration_one;
        duration_two = duration_for_load;
        note_three = 6'b0;
        duration_three = 6'b0;
        note_sample = 16'b0;
      end 
      `NOTE_THREE: begin
        next_state = `ADVANCE_TIMEE;
        note_two = note_two;
        duration_one = duration_one;
        note_one = note_one;
        duration_two = duration_two;
        note_three = note_to_play;
        duration_three = duration_for_play;
        note_sample = 16'b0;
      end 
      `ADVANCE_TIMEE begin
        next_state = `NOTE_ONE;
        note_sample = sample_one>>2 + sample_two>>2 + sample_three>>2;
    );
      end 
      default: begin
        next_state = `NOTE_ONE;
        note_one = 6'b0;
        note_two = 6'b0;
        note_three = 6'b0;
        note_sample = 16'b0;
      end
    endcase
        
   note_player note_player_1
        .clk(clk),
        .reset(reset),
        .play_enable(play),
        .note_to_load(note_one),
        .duration_to_load(duration_one),
        .load_new_note(new_note),
        .done_with_note(note_done),
        .beat(beat),
        .generate_next_sample(generate_next_sample),
        .sample_out(sample_one),
        .new_sample_ready(note_sample_ready)
    );
    
    note_player note_player_2
        .clk(clk),
        .reset(reset),
        .play_enable(play),
        .note_to_load(note_two),
        .duration_to_load(duration_two),
        .load_new_note(new_note),
        .done_with_note(note_done),
        .beat(beat),
        .generate_next_sample(generate_next_sample),
        .sample_out(sample_two),
        .new_sample_ready(note_sample_ready)
    );
    
    note_player note_player_3
        .clk(clk),
        .reset(reset),
        .play_enable(play),
        .note_to_load(note_three),
        .duration_to_load(duration_three),
        .load_new_note(new_note),
        .done_with_note(note_done),
        .beat(beat),
        .generate_next_sample(generate_next_sample),
        .sample_out(sample_three),
        .new_sample_ready(note_sample_ready)
    );
      
//   
//  ****************************************************************************
//      Beat Generator
//  ****************************************************************************
//  By default this will divide the generate_next_sample signal (48kHz from the
//  codec's new_frame input) down by 1000, to 48Hz. If you change the BEAT_COUNT
//  parameter when instantiating this you can change it for simulation.
//  
    beat_generator #(.WIDTH(10), .STOP(BEAT_COUNT)) beat_generator(
        .clk(clk),
        .reset(reset),
        .en(generate_next_sample),
        .beat(beat)
    );

//  
//  ****************************************************************************
//      Codec Conditioner
//  ****************************************************************************
//  
    
    assign new_sample_generated = generate_next_sample;

  
     codec_conditioner codec_conditioner(
        .clk(clk),
        .reset(reset),
        .new_sample_in(note_sample),
        .latch_new_sample_in(note_sample_ready),
        .generate_next_sample(generate_next_sample),
        .new_frame(new_frame),
        .valid_sample(sample_out)



endmodule
