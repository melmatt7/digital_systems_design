`default_nettype none
parameter def_speed = 32'd1136;

module Speed_Control (//input
							 clk, speed_up, speed_down, speed_reset,
							 //output
							 div_count);
	 input clk, speed_up, speed_down, speed_reset;
	 output reg [31:0] div_count;
	 
	 reg [31:0] count = def_speed;
	 
	 always_ff @(posedge clk) begin
		case({speed_up, speed_down, speed_reset})
			3'b001: count <= def_speed;
			3'b010: count <= count - 32'd16;
			3'b100: count <= count + 32'd16;
		endcase
	 end
	 
	 assign div_count = count;
 endmodule