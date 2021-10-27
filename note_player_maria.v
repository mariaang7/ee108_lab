module note_player(
    input clk,
    input reset,
    input play_enable,  // When high we play, when low we don't.
    input [5:0] note_to_load,  // The note to play
    input [5:0] duration_to_load,  // The duration of the note to play
    input load_new_note,  // Tells us when we have a new note to load
    output done_with_note,  // When we are done with the note this stays high.
    input beat,  // This is our 1/48th second beat
    input generate_next_sample,  // Tells us when the codec wants a new sample
    output [15:0] sample_out,  // Our sample output
    output new_sample_ready  // Tells the codec when we've got a sample
);

`define STATE_INITIAL 2'b00
`define STATE_PLAYING 2'b01
`define STATE_PAUSE 2'b10
`define STATE_DONE 2'b11

reg [1:0] next_state;
wire [1:0] state;
dffr #(2) state_dff (.clk(clk), .r(reset), .d(next_state), .q(state));

reg [5:0] next_count_beat;
wire [5:0] count_beat;
dff #(6) counter_beat(.clk(clk), .d(next_count_beat), .q(count_beat));

always @(*) begin
    case(state) 
    2'b00: begin
        next_state = play_enable ? 2'b01 : 2'b10;
        next_count_beat = 5'b0;
    end
    2'b01: begin
        next_state = play_enable ? ((count_beat == duration_to_load) ? 2'b11 : 2'b01) : 2'b10;
        next_count_beat = (!play_enable || (count_beat == duration_to_load)) ? count_beat : count_beat + 5'b1;
    end
    2'b10: begin
        next_state = play_enable ? 2'b01 : 2'b10;
        next_count_beat = count_beat;
    end
    2'b11: begin
        next_state = (load_new_note && play_enable) ? 2'b00 : ((!play_enable) ? 2'b10 : 2'b11);
        next_count_beat = count_beat;
    end
    endcase
            
end

wire [19:0] step_size;

frequency_rom note_step_size (.clk(clk), .addr(note_to_load), .dout(step_size));

sine_reader synth (.clk(clk), .reset(reset), .step_size(step_size), .generate_next(generate_next_sample), .sample_ready(new_sample_ready), .sample(sample_out));
    
assign done_with_note = (count_beat == duration_to_load);


endmodule

