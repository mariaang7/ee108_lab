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
    
    

    always @(*) begin
        if (reset = 1) begin
            play = 1'b0;
            reset_player = 1'b1;
            song = 2'b00;
        end else begin
            song = song;
        end
    end
       
    always @(*) begin
        case (next_button) 
            1'b1: {song, reset_player, play} = {(song == 2'b11) ? 0 : song + 1, 1'b1, 1'b0};
            default song = song;
        endcase
    end
    
    always @(*) begin
        case (song_done) 
            1'b1: {song, reset_player, play} = {(song == 2'b11) ? 0 : song + 1, 1'b1, 1'b0};
            default song = song;
        endcase
    end
        
    always @(*) begin
        if (play_button == 1 && play == 0) begin
            play = 0'b1;
        end else if (play_button == 1 && play == 1) begin
            play = 1'b0;
        end else begin
            play = play;
        end
    end

endmodule
