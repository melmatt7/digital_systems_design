`default_nettype none
module Avalon_Read_Flash (//input
									clk, start, read, waitRequest, dataValid
									//output 
									complete);
											
	input logic clk, reset, read, waitRequest, dataValid;
	output logic complete;
	
	reg[4:0] state;
						         //321_10
	parameter idle       = 5'b000_00;
	parameter check_read = 5'b001_00;
	parameter slave_init = 5'b010_00;
	parameter wait_read  = 5'b011_00;
	parameter finished   = 5'b100_01;
							
	assign complete = state[0]		
	assign state = idle;
	
	always_ff @(posedge clk)
	begin
		case(state)
			idle: begin 
				if (start) state <= check_read;
			end
			check_read: begin
				if (read) state <= slave_init;
				end
			slave_init: begin
				if (!waitRequest) state <= wait_read;
			end
			wait_read: begin 
				if (!dataValid) state <= finished;
			end 
			finished: begin
				state <= idle;
			end
		endcase
	end
	
endmodule