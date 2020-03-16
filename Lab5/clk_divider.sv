`default_nettype none
module clk_divider(//input
						 inclk, div_clk_count, reset,
						 //output 
						 outclk);
    input inclk;
	 input reset;
	 input[31:0] div_clk_count;
	 output outclk;
	 
	 reg[31:0] curr_count = 32'd0;
	 
	 always @(posedge inclk) begin
		if (reset) begin
			outclk = 0;
			curr_count = 0;
		end
		else if (curr_count < div_clk_count - 1) begin
			curr_count = curr_count + 1;
		end
		else begin
			outclk = ~outclk;
			curr_count = 0;
		end
	end
	
endmodule