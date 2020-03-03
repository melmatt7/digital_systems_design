module trap_edge(input async_sig, 
				 input clk,
				 input reset,
				 output trapped_edge);
			
wire f1_out;

flipflop f1 (
.clk(async_sig),
.clr(0),
.q(f1_out),
.d(1)
);
			
flipflop f2 (
.clk(clk),
.clr(reset),
.q(trapped_edge),
.d(f1_out)
);
			
endmodule
			

module flipflop(clk, clr, q, d);
	input clk;
	input clr;
	input d;
	output reg q;

	
	always @(posedge clk or posedge clr) begin
		if (clr == 1) begin
			q <= 0;
		end
		else begin 
			q <= d;
		end
	end
	
endmodule