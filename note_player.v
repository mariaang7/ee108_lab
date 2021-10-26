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

    reg [5:0] count;
    wire [19:0] frequency;
    frequency_rom note (.clk(clk), .addr(note_to_load), .dout(frequency));
    
    sine_reader dyd (.clk(clk), .reset(reset), .step_size(frequency), .generate_next(generate_next_sample), .sample_ready(new_sample_ready), .sample(sample_out));
    
    always @(*) begin
        if (beat == 1'b1 && duration_to_load != count) begin
            count += 1;
        end else if (duration == count) begin
            done_with_note = 1'b1;
            count = 1'b0;
        end else begin
            done_with_note = 1'b0;
        end
    end
    
    
         

endmodule
