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
`define ADVANCE_TIME       3'b101


module song_reader(
    input clk,
    input reset,
    input play,
    input [1:0] song,
    output wire song_done,
    input wire note_one_done,
    input wire note_two_done,
    input wire note_three_done,
    input beat,
    output reg [5:0] note_one,
    output reg [5:0] note_two,
    output reg [5:0] note_three,
    output reg [5:0] duration_one,
    output reg [5:0] duration_two,
    output reg [5:0] duration_three,
    output reg new_note_one,
    output reg new_note_two,
    output reg new_note_three
);
    
    wire advance_done;
    wire [`SONG_WIDTH-1:0] curr_note_num, next_note_num;
    wire [`NOTE_WIDTH + `DURATION_WIDTH + 4 - 1:0] note_and_duration;
    wire [`SONG_WIDTH + 1:0] rom_addr = {song, curr_note_num - 1'b1};  //or without - 1'b1
    wire [5:0] note;
    wire note_done = 1'b0;
    

    wire [`SWIDTH-1:0] state;
    reg  [`SWIDTH-1:0] next;
    wire  [5:0] final_duration;

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
    
    wire new_note;
    wire [5:0] duration;
    
    wire load_advancer;
    wire next_load_advancer;
    wire [5:0] advance_duration;
    
    wire msb = note_and_duration[15]; 
    song_rom rom(.clk(clk), .addr(rom_addr), .dout(note_and_duration));
    //beat_generator dd2 (.clk(clk), .reset(reset), .en(msb), .beat(beat));
    //one_pulse_beat #(1) jksgh2 (.clk(clk), .reset(reset), .beat(beat), .in(next_load_advancer), .out(load_advancer));
    //assign load_duration = load_advancer;
    time_advancer advance (.clk(clk), .reset(reset), .load_duration(load_advancer), .duration(advance_duration), .beat(beat), .advance_done(advance_done));
    //beat_generator dd (.clk(clk), .reset(reset), .en(msb), .beat(beat));
    //assign note_done = (note_one_done || note_two_done || note_three_done);
    
    always @(*) begin
        case (state)
            `PAUSED:            next = play ? `RETRIEVE_NOTE : `PAUSED;
            `RETRIEVE_NOTE:     next = play ? (msb ? `ADVANCE_TIME : `NEW_NOTE_READY) : `PAUSED;
            `NEW_NOTE_READY:    next = play ? `WAIT: `PAUSED;
            `WAIT:              next = !play ? `PAUSED
                                             : ((msb == 0 || advance_done) ? `INCREMENT_ADDRESS
                                                          : `WAIT);
            `ADVANCE_TIME:      next = play ? `INCREMENT_ADDRESS : `ADVANCE_TIME;
            `INCREMENT_ADDRESS: next = (play && ~overflow) ? `RETRIEVE_NOTE
                                                           : `PAUSED;
            default:            next = `PAUSED;
        endcase
    end

    assign next_load_advancer = (msb) ? 1'b1 : 1'b0;
    
    //one_pulse_beat #(1) jksgh (.clk(clk), .reset(reset), .beat(beat), .in(next_load_advancer), .out(load_advancer));
    
    assign {overflow, next_note_num} =
         (state == `INCREMENT_ADDRESS) ? {1'b0, curr_note_num} + 1
                                       : {1'b0, curr_note_num};
    assign new_note = (state == `NEW_NOTE_READY);
    assign {note, duration} = note_and_duration[14:3];
    assign song_done = overflow;
    assign advance_duration = msb ? note_and_duration[14:9] : 6'b0;
    
//    always @(*) begin
//        if (reset) begin
//            {note_one, note_two, note_three} = 18'b0;
//            {duration_one, duration_two, duration_three} = 18'b0;
//        end else if (note_one_done) begin
//            note_one = note;
//            duration_one = duration;
//            new_note_one = 1'b1;
//        end else if (note_two_done) begin
//            note_two = note;
//            duration_two = duration;
//            new_note_two = 1'b1;
//        end else if (note_three_done) begin
//            note_three = note;
//            duration_three = duration;
//            new_note_three = 1'b1;
//        end else begin
//            {new_note_one, new_note_two, new_note_three} = {1'b0, 1'b0, 1'b0};
            
//        end
//    end

    wire [2:0] notes_done = {note_one_done, note_two_done, note_three_done};
    always @(*) begin
        casex (notes_done)
            3'b1xx: 
                begin
                    note_one = note;
                    duration_one = duration;
                    new_note_one = 1'b1;
               end
            3'b01x: 
                begin
                    note_two = note;
                    duration_two = duration;
                    new_note_two = 1'b1;
                end
            3'b001:
                begin 
                    note_three = note;
                    duration_three = duration;
                    new_note_three = 1'b1;
                end
            default:
                begin
                    {note_one, note_two, note_three} = 18'b0;
                    {duration_one, duration_two, duration_three} = 18'b0;
                    {new_note_one, new_note_two, new_note_three} = 3'b0;
                end
        endcase
    end
             

endmodule