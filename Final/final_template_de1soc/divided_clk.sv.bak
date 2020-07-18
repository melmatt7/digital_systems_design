module Divided_Clk(inclk,outclk,div_clk_count,Reset);
    input inclk;
	 input Reset;
    output outclk;
	 input[31:0] div_clk_count;
	 
	 reg[31:0] curr_count = 32'd0;
	 
	 always @(posedge inclk) begin
		if (Reset) begin
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