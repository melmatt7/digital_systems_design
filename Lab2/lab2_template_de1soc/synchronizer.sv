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
	wire q3;
	
	Flipflop
	fdc1(
	.clk(outclk),
	.clr(gnd),
	.q(q1),
	.d(out_sync_sig)	
	);
	
	Flipflop
	fdc2(
	.clk(async_sig),
	.clr(q1),
	.q(q2),
	.d(vcc)
	);
	
	Flipflop
	fdc3(
	.clk(outclk),
	.clr(gnd),
	.q(q3),
	.d(q2)	
	);
	
	Flipflop
	fdc4(
	.clk(outclk),
	.clr(gnd),
	.q(out_sync_sig),
	.d(q3)
	);
	
endmodule	