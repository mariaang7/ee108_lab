`define SONG_WIDTH 7
`define NOTE_WIDTH 6
`define DURATION_WIDTH 6

// ----------------------------------------------
// Define State Assignments
// ----------------------------------------------
`define SWIDTH 3
`define PAUSED             3'b000
`define NOTE_1             3'b001
`define NOTE_2             3'b010
`define NOTE_3             3'b011
`define ADVANCE_TIME       3'b100


module song_reader(
    input clk,
    input reset,
    input play,
    input beat,
    input [1:0] song,
    input note_done,
    output reg song_done,
    output reg [17:0] notes_out, durations_out,
    output wire new_note,
    output advance_done
);
    wire [`SONG_WIDTH-1:0] curr_note_num, next_note_num;
    wire [`NOTE_WIDTH + `DURATION_WIDTH + 3:0] note_and_duration;
    wire [`SONG_WIDTH + 1:0] rom_addr = {song, curr_note_num - 1}; //subtract 1 to start from 0

    wire [`SWIDTH-1:0] state;
    reg  [`SWIDTH-1:0] next;

    dffr #(`SONG_WIDTH) note_counter (
        .clk(clk),
        .r(reset),
        .d(next_note_num),
        .q(curr_note_num)
    );
    
    reg increment;
    
    assign next_note_num =
        increment ? curr_note_num + 1'b1
                                      : curr_note_num;
    
    dffr #(`SWIDTH) fsm (
        .clk(clk),
        .r(reset),
        .d(next),
        .q(state)
    );
    
    wire [15:0] rom_out;
    song_rom rom(.clk(clk), .addr(rom_addr), .dout(rom_out));
    
    wire msb;
    assign msb = rom_out[15];
    wire [5:0] curr_note, curr_duration;
    assign {curr_note, curr_duration} = {rom_out[14:9], rom_out[8:3]};
    
    reg [5:0] note_one, duration_one, note_two, duration_two, note_three, duration_three;
    
    reg [5:0] advance_duration;
    
    always @(*) begin
        case (state)
            `PAUSED: 
                begin            
                    next = play ? (msb ? `ADVANCE_TIME : `NOTE_1) : `PAUSED;
                    increment = 1'b0;
                    notes_out = 18'b0;
                    durations_out = 18'b0;
                end
            `NOTE_1:
                begin
                    next = play ? `NOTE_2 : `PAUSED;
                    note_one = curr_note;
                    duration_one = curr_duration;
                    increment = 1'b1;
                end
            `NOTE_2:
                begin
                    next = play ? `NOTE_3 : `PAUSED;
                    note_two = curr_note;
                    duration_two = curr_duration;
                    increment = 1'b1;
                end
            `NOTE_3:
                begin
                    next = play ? `ADVANCE_TIME : `PAUSED;
                    note_three = curr_note;
                    duration_three = curr_duration;
                    increment = 1'b1;
                end
              `ADVANCE_TIME:
                begin
                    next = play ? (advance_done ? `NOTE_1 : `ADVANCE_TIME) : `PAUSED ;
                    advance_duration = curr_duration;
                    notes_out = new_note ? {note_one, note_two, note_three} : 18'b0;
                    durations_out = new_note ? {duration_one, duration_two, duration_three} : 18'b0;
                    increment = advance_done ? 1'b1 : 1'b0;
                end
            default:
                begin
                    next = `PAUSED;
                end
        endcase
    end
    
    
    wire [5:0] advance_t, next_advance_t;
    dffre #(.WIDTH(6)) dff_advance_t (
        .clk(clk),
        .r(reset),
        .en(play && (state == `ADVANCE_TIME)),
        .d(next_advance_t),
        .q(advance_t)
    );
    assign next_advance_t = (reset || advance_done)
                        ? advance_duration - 6'b1 : (beat ? advance_t - 6'b1 : advance_t);

    assign advance_done = (advance_t == 6'b0);

    assign new_note  = (advance_t == advance_duration - 1'b1 && (state == `ADVANCE_TIME)) ? 1'b1 : 1'b0;
    
    always @(*) begin
        case(song)
            2'b00: song_done = (rom_addr == 9'd127) ? 1'b1 : 1'b0;
            2'b01: song_done = (rom_addr == 9'd255) ? 1'b1 : 1'b0;
            2'b10: song_done = (rom_addr == 9'd383) ? 1'b1 : 1'b0;
            2'b11: song_done = (rom_addr == 9'd511) ? 1'b1 : 1'b0;
        endcase
       end
       

endmodule
