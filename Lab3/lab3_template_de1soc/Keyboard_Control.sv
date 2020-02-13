`default_nettype none

module Keyboard_Control(//inputs
					  clk, kbd_data_ready, read_complete, key_pressed,
					  //outputs
					  reset, read_signal, direction
					  );

	input clk, kbd_data_ready, read_complete;
	input [0:7] key_pressed;
	
	output reset, read_signal, direction;
	
	parameter character_E =8'h45;
   parameter character_lowercase_e= 8'h65;
   parameter character_D =8'h44;
   parameter character_lowercase_d= 8'h64;
   parameter character_B =8'h42;
   parameter character_lowercase_b= 8'h62;
   parameter character_F =8'h46;
   parameter character_lowercase_f= 8'h66;
   parameter character_R =8'h52;
   parameter character_lowercase_r= 8'h72;
	
	reg[5:0] state = 6'b001_001;						
								         //543_210
	parameter pause_forward    = 6'b001_001;
	parameter pause_backward   = 6'b010_000;
	parameter play             = 6'b011_011;
	parameter back             = 6'b100_010;
	parameter restart_forward  = 6'b101_110;
	parameter restart_backward = 6'b110_110;
	
	assign reset = state[2];
	assign read_signal = state[1];
	assign direction = state[0];
	
	always_ff @(posedge clk)
	begin
		case(state)
			pause_forward: begin
				if(key_pressed == character_E || key_pressed == character_lowercase_e) 
					state <= play;
			end
			play: begin
				if(key_pressed == character_D || key_pressed == character_lowercase_d) 
					state <= pause_forward;
				else if(key_pressed == character_B || key_pressed == character_lowercase_b)
					state <= back;
				else if(key_pressed == character_R || key_pressed == character_lowercase_r)
					if(kbd_data_ready) state <= restart_forward;
			end
			pause_backward: begin
				if(key_pressed == character_E || key_pressed == character_lowercase_e) 
					state <= back;
			end
			back: begin
				if(key_pressed == character_D || key_pressed == character_lowercase_d) 
					state <= pause_backward;
				else if(key_pressed == character_F || key_pressed == character_lowercase_f)
					state <= play;
				else if(key_pressed == character_R || key_pressed == character_lowercase_r)
					if(kbd_data_ready) state <= restart_backward;
			end
			restart_forward: begin
				if(read_complete) state <= play;
			end
			restart_backward: begin
				if(read_complete) state <= back;
			end
		endcase
	end
	
endmodule
