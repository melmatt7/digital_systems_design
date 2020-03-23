module fast_to_slow_sync (//inputs
								  fast_clk,
								  slow_clk,
								  data_in,
								  //outputs
								  data_out
								  );
								  
input fast_clk, slow_clk;
input [11:0] data_in;
output [11:0] data_out;

reg[11:0] reg1_out, reg3_out;
wire f1_out, f2_out;

flipflop #(12) reg1 (.clk(fast_clk), .en(1'b1), .d(data_in), .q(reg1_out)); 
flipflop #(12) reg3 (.clk(fast_clk), .en(f2_out), .d(reg1_out), .q(reg3_out)); 
flipflop #(12) reg2 (.clk(slow_clk), .en(1'b1), .d(reg3_out), .q(data_out));  

flipflop #(1) f1 (.clk(~fast_clk), .en(1'b1), .d(slow_clk), .q(f1_out)); 
flipflop #(1) f2 (.clk(~fast_clk), .en(1'b1), .d(f1_out), .q(f2_out)); 

endmodule



