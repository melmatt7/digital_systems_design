`timescale 1ns / 1ps
module Flipflop(clk, clr, q, d);
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