module s_memory_write(
	init_sig,
	clk,
	complete,
	q);

	input	  clk;
	input init_sig;
	output complete;
	output	[7:0]  q;	
	
	reg[1:0] state   = 2'b0_00;						
					    //32_10
	parameter idle   = 4'b00_00;
	parameter init   = 4'b01_10;
	parameter finish = 4'b10_01;

	assign init_write = state[1];
	assign complete = state[0];
	
	reg[7:0] counter = 8'b0;
	
	always_ff @(posedge clk)
	begin
		case(state) 
			idle:
				if(init_sig) state <= init;
			init:
				if(counter > 8'hFE) state <= complete;
			finish:
				state <= idle;

		endcase
	end


	always_ff @(posedge clk) 
	begin
		if (init_write)
		begin			
			counter = counter + 1;			
		end
	end

	s_memory
	s_memory_insta(
	.address(counter),
	.clock(clk),
	.data(counter),
	.wren(init_write),
	.q(s_mem_out)
	);	
	
endmodule