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

wire [19:0] step_size;
reg next_count_beat;
wire count_beat;

    // Implementation goes here!
    frequency_rom note_step_size (.clk(clk), .addr(note_to_load), .dout(step_size));
    
    always @(*) begin
        case(count_beat) 
            duration_to_load: next_count_beat = load_new_note ? 1'b0 : count_beat;
            default: next_count_beat = (beat && !load_new_note) ? count_beat + 1 : count_beat;
        endcase
    end 
    
    assign done_with_note = (count_beat == duration_to_load) ? 1'b1 : 1'b0;
   
    dffre #(1) counter_beat(.clk(clk), .r(reset), .en(play_enable), .d(next_count_beat), .q(count_beat));
    // call sine_reader
    
    

endmodule
