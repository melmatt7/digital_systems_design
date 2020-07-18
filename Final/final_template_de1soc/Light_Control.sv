`default_nettype none
module Light_Control(//input
							clk, audio, read_sig,
							//output
							led);
	input clk, read_sig;
	input [7:0] audio;
	output reg[7:0] led = 8'b0000_0000;
	
	reg[8:0] count = 9'b0; 
	reg[15:0] sum = 16'b0;
	reg[7:0] audio_abs;

  	reg[2:0] state 		  = 3'b000;						
							 //210
	parameter incr_count  = 3'b000;
	parameter check_count = 3'b001;
	parameter abs         = 3'b010;
	parameter addavg      = 3'b011;
	parameter display     = 3'b100;
	parameter reset 		 = 3'b101;

	
	always_ff @(posedge clk)
	begin
		case(state)
			incr_count: begin
				if(read_sig) state <= check_count;
			end
			check_count: begin 
				if(count > 9'd256) state <= display;
				else state <= abs;
			end
			abs: begin 
				state <= addavg;
			end
			addavg: begin
				state <= incr_count;
			end
			display: begin
				state <= reset;
			end
			reset: begin
				state <= incr_count;
			end
		endcase
	end
	
	always_ff @(posedge clk)
	begin
		case(state)
			incr_count: begin
				count <= count + 1;
			end
			reset: begin
				count <= 9'b0;
			end
		endcase
	end
	
	always_ff @(posedge clk)
	begin
		case(state)
			abs: begin
				if (audio[7] == 1'b1) audio_abs <= ~audio + 1;
				else audio_abs <= audio;
			end
		endcase
	end
	
	always_ff @(posedge clk)
	begin
		case(state)
			addavg: begin
				sum <= sum + audio_abs;
			end
			reset: begin
				sum <= 16'b0;		
			end
		endcase
	end
	
	always_ff @(posedge clk)
	begin
		case(state)
			display: begin
				if     (sum[15:8] > 8'b1000_0000) led <= 8'b1111_1111;
				else if(sum[15:8] > 8'b0100_0000) led <= 8'b1111_1110;
				else if(sum[15:8] > 8'b0010_0000) led <= 8'b1111_1100;
				else if(sum[15:8] > 8'b0001_0000) led <= 8'b1111_1000;
				else if(sum[15:8] > 8'b0000_1000) led <= 8'b1111_0000;
				else if(sum[15:8] > 8'b0000_0100) led <= 8'b1110_0000;
				else if(sum[15:8] > 8'b0000_0010) led <= 8'b1100_0000;
				else 								    led <= 8'b1000_0000;
			end
		endcase
	end	
endmodule