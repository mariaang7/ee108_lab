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
  
  //0: pause, 1: play
  
  reg state; 
  wire new_state;
  
  dffr #(1) mcu_dff (.clk(clk), .r(reset), .d(new_state), .q(state));
  
  always @(*) begin
    case(state)
      1'b0: begin 
        play = 1'b0;
        next_state = (play_button) ? 1'b1 : 1'b0;
      end
      1'b1: begin
        play = 1'b1;
        next_state = (play_button || song_done || next_button) ? 1'b0 : 1'b1;
      end
    endcase
  end 
  
  reg [1:0] curr_song;
  
  dffr #(2) song_counter (.clk(clk), .r(reset), .d(new_song), .q(curr_song));
  
  always @(*) begin
    case(curr_song)
      2'b00: next_song = (song_done || next_button) ? 2'b01 : 2'b00;
      2'b01: next_song = (song_done || next_button) ? 2'b10 : 2'b01;
      2'b10: next_song = (song_done || next_button) ? 2'b11 : 2'b10;
      2'b11: next_song = (song_done || next_button) ? 2'b00 : 2'b11;
    endcase
  end
      
    assign song = curr_song;
  
endmodule
      
