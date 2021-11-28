`define SONG_WIDTH 5
`define NOTE_WIDTH 6
`define DURATION_WIDTH 6

// ----------------------------------------------
// Define State Assignments
// ----------------------------------------------
`define SWIDTH 3
`define PAUSED             3'b000
`define WAIT               3'b001
`define INCREMENT_ADDRESS  3'b010
`define RETRIEVE_NOTE      3'b011
`define NEW_NOTE_READY     3'b100


module song_reader(
    input clk,
    input reset,
    input play,
    input [1:0] song,
    input note_done,
    input rewind,
    input ff,
    output wire song_done,
    output wire [5:0] note,
    output wire [5:0] duration,
    output wire new_note
);
    wire [`SONG_WIDTH-1:0] curr_note_num, next_note_num;
    wire [`NOTE_WIDTH + `DURATION_WIDTH -1:0] note_and_duration;
    wire [`SONG_WIDTH + 1:0] rom_addr = {song, curr_note_num};

    wire [`SWIDTH-1:0] state;
    reg  [`SWIDTH-1:0] next;
    wire [`DURATION_WIDTH - 1:0] final_duration;
    wire [`DURATION_WIDTH - 1:0] temp_duration;

    // For identifying when we reach the end of a song
    wire overflow;

    dffr #(`SONG_WIDTH) note_counter (
        .clk(clk),
        .r(reset),
        .d(next_note_num),
        .q(curr_note_num)
    );
    dffr #(`SWIDTH) fsm (
        .clk(clk),
        .r(reset),
        .d(next),
        .q(state)
    );

    song_rom rom(.clk(clk), .addr(rom_addr), .dout(note_and_duration));

    always @(*) begin
        case (state)
            `PAUSED:            next = play ? `RETRIEVE_NOTE : `PAUSED;
            `RETRIEVE_NOTE:     next = play ? `NEW_NOTE_READY : `PAUSED;
            `NEW_NOTE_READY:    next = play ? `WAIT: `PAUSED;
            `WAIT:              next = !play ? `PAUSED
                                             : (note_done ? `INCREMENT_ADDRESS
                                                          : `WAIT);
            `INCREMENT_ADDRESS: next = (play && ~overflow) ? `RETRIEVE_NOTE
                                                           : `PAUSED;
            default:            next = `PAUSED;
        endcase
    end

    assign {overflow, next_note_num} =
        (state == `INCREMENT_ADDRESS) ? (rewind ? {1'b0, curr_note_num} - 1 : {1'b0, curr_note_num} + 1)
                                      : {1'b0, curr_note_num};
    assign new_note = (state == `NEW_NOTE_READY);
    assign temp_duration = note_and_duration[5:0];
    assign final_duration = (ff || rewind) ? (temp_duration >> 1) : temp_duration;
    assign {note, duration} = {note_and_duration[11:6], final_duration};
    assign song_done = overflow;

endmodule
