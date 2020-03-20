`default_nettype none
module flipflop(//input
					clk, en, d, 
					//output
					q);
	
	parameter n = 12;
	input clk;
	input en;
	input[n-1:0] d;
	output reg[n-1:0] q;

	
	always @(posedge clk) begin
		if (en) begin
			q <= d;
		end
		else begin 
			q <= d;
		end
	end
	
endmodule