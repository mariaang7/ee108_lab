module mcu(
    input clk,
    input reset,
    input play_button,
    input next_button,
    output play,
    output reset_player,
    output [1:0] song,
    input song_done
);
    
    reg next_song;
    reg next_play;
    
    dffr #(22) counter(.clk (clk),.r (reset),.d (next_song), .q (song));
    dffr #(22) counter(.clk (clk),.r (reset),.d (next_play), .q (play));

    always @(*) begin
        if (reset = 1) begin
            next_play = 1'b0;
            reset_player = 1'b1;
            next_song = 2'b00;
        end else begin
            next_song = song;
        end
    end
       
    always @(*) begin
        case (next_button) 
            1'b1: {next_song, reset_player, next_play} = {(song == 2'b11) ? 0 : song + 1, 1'b1, 1'b0};
            default next_song = song;
        endcase
    end
    
    always @(*) begin
        case (song_done) 
            1'b1: {next_song, reset_player, next_play} = {(song == 2'b11) ? 0 : song + 1, 1'b1, 1'b0};
            default next_song = song;
        endcase
    end
        
    always @(*) begin
        if (play_button == 1 && play == 0) begin
            next_play = 0'b1;
        end else if (play_button == 1 && play == 1) begin
            next_play = 1'b0;
        end else begin
            next_play = play;
        end
    end

endmodule
