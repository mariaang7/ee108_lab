`define SONG_WIDTH 7
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
    input note_one_done, note_two_done, note_three_done,
    //input rewind,
    //input ff,
    input beat,
    output song_done,
    output  [5:0] note_one, note_two, note_three,
    output  [5:0] duration_one, duration_two, duration_three,
    output reg new_note_one, new_note_two, new_note_three
);
    wire [`SONG_WIDTH - 1:0] curr_note_num, next_note_num;
    wire [15:0] note_and_duration;
    wire [`SONG_WIDTH + 1:0] rom_addr = {song, curr_note_num - 1'b1};

    wire [`SWIDTH-1:0] state;
    reg  [`SWIDTH-1:0] next;

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
    
    wire msb;
    wire [5:0] note, duration;

    song_rom rom(.clk(clk), .addr(rom_addr), .dout(note_and_duration));
    assign {msb, note, duration} = {note_and_duration[15], note_and_duration[14:9], note_and_duration[8:3]};
    
  
    wire advance_done;  
    wire [5:0] state_t, next_state_t;
    dffre #(6) advance_t (
        .clk(clk),
        .r(reset),
        .en(msb && play),
        .d(next_state_t),
        .q(state_t)
    );

    assign next_state_t = (advance_done)
                        ? duration : (beat ? state_t - 1 : state_t);

    assign advance_done = (state_t == 6'b0);

    reg increment;
    
    always @(*) begin
        case (state)
            `PAUSED:            next = play ? (msb ? `WAIT : `RETRIEVE_NOTE) : `PAUSED;
            `RETRIEVE_NOTE:     next = play ? (msb ? `WAIT : `NEW_NOTE_READY) : `PAUSED;
            `NEW_NOTE_READY:    next = play ? `WAIT : `PAUSED;
            `WAIT:              next = ~play ? `PAUSED : (((increment && ~msb) || advance_done) ? `INCREMENT_ADDRESS
                                                          : `WAIT);
            `INCREMENT_ADDRESS: next = (play && ~overflow) ? `RETRIEVE_NOTE
                                                           : `PAUSED;
            default:            next = `PAUSED;
        endcase
    end
    
//    assign {overflow, next_note_num} =
//        (state == `INCREMENT_ADDRESS) ? {1'b0, curr_note_num} + 1 : {1'b0, curr_note_num};]

assign {overflow, next_note_num} =
    (increment || advance_done) ? {1'b0, curr_note_num} + 1 : {1'b0, curr_note_num};
        
    wire new_note;
    assign new_note = (state == `NEW_NOTE_READY);

    assign song_done = overflow;
    
    reg note_one_busy, note_two_busy, note_three_busy;
    
//    wire [2:0] notes_done = {note_one_done, note_two_done, note_three_done};
//    always @(*) begin
//        casex({reset, notes_done})
//            4'b01xx: note_one_busy = 1'b0;
//            4'b0x1x: note_two_busy = 1'b0;
//            4'b0xx1: note_three_busy = 1'b0;
//            4'b1xxx: {note_one_busy, note_two_busy, note_three_busy} = 3'b0;
//        endcase
//     end
    
    wire [2:0] notes_done = {note_one_done, note_two_done, note_three_done};
 
    reg [11:0] next_one, next_two, next_three;
    wire [11:0] one, two, three;
    
    dffr#(12) dff_one (.clk(clk), .r(reset), .d(next_one), .q(one));
    dffr#(12) dff_two (.clk(clk), .r(reset),.d(next_two), .q(two));
    dffr#(12) dff_three (.clk(clk), .r(reset), .d(next_three), .q(three));
    
    always @(*) begin
        casex(notes_done)
            3'b1xx: 
                begin
                    next_one = {note, duration};
                    new_note_one = 1'b1;
                    increment = 1'b1;
                    next_two = two;
                    new_note_two = 1'b0;
                    next_three = three;
                    new_note_three = 1'b0;
               end
            3'b01x: 
                begin
                    next_two = {note, duration};
                    new_note_two = 1'b1;
                    increment = 1'b1;
                    next_one = one;
                    new_note_one = 1'b0;
                    next_three = three;
                    new_note_three = 1'b0;
                end
            3'b001:
                begin 
                    next_three = {note, duration};
                    new_note_three = 1'b1;
                    increment = 1'b1;
                    next_two = two;
                    new_note_two = 1'b0;
                    next_one = one;
                    new_note_one = 1'b0;
                end
            default: begin
                next_one = one;
                new_note_one = 1'b0;
                next_two = two;
                new_note_two = 1'b0;
                next_three = three;
                new_note_three = 1'b0;
                increment = 1'b0;
             end 
        endcase
    end
    
    assign note_one = one[11:6];
    assign duration_one = one[5:0];
    assign note_two = two[11:6];
    assign duration_two = two[5:0];
    assign note_three = three[11:6];
    assign duration_three=three[5:0];
    

    

endmodule
