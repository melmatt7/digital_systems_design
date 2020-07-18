//`default_nettype none
module Synchronizer (//input
							async_sig, outclk, 
							//output
							out_sync_sig);
	input async_sig;
	input outclk;
	output out_sync_sig;
		
	wire vcc = 1;
	wire gnd = 0;
	
	wire q1;
	wire q2;
	wire q4;
	
	Flipflop
	fdc1(
	.clk(async_sig),
	.clr(q4),
	.q(q1),
	.d(vcc)	
	);
	
	Flipflop
	fdc2(
	.clk(outclk),
	.clr(gnd),
	.q(q2),
	.d(q1)
	);
	
	Flipflop
	fdc3(
	.clk(outclk),
	.clr(gnd),
	.q(out_sync_sig),
	.d(q2)	
	);
	
	Flipflop
	fdc4(
	.clk(outclk),
	.clr(gnd),
	.q(q4),
	.d(out_sync_sig)
	);
	
endmodule	