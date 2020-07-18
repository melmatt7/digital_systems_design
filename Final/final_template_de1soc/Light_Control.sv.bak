`default_nettype none
module Light_Control(//input
							inclk,
							//output
							led);
	input inclk;
	output reg[7:0] led = 8'b1000_0000;
	
	reg direction = 1'b0; // 0 means shift left, 1 means shift right
	
	always @(posedge inclk) begin
		if ((led[7] == 1 & direction == 0) | (led[0] == 1 & direction == 1)) begin
			direction = ~direction;
		end
		
		if (direction == 0) begin
			led = led << 1;
		end
		else if (direction == 1) begin 
			led = led >> 1;
		end
	end
				
endmodule