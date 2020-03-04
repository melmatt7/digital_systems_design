//module s_memory_write(
	// init_sig, 
	// clk,
	// complete,
	// q);

	// input	  clk;
	// input init_sig;
	// output complete;
	// output	[7:0]  q;	
	
	// reg[7:0] s_mem_out_shuffle = 8'b0;
	// reg[1:0] state   = 2'b0_00;						
	// 				    //32_10
	// parameter idle   = 4'b00_00;
	// parameter init   = 4'b01_10;
	// parameter finish = 4'b10_01;

	// assign init_write = state[1];
	// assign complete = state[0];
	
	// reg[7:0] i_init = 8'b0;
	// reg[7:0] i_shuffle = 8'b0;
	// reg[7:0] j = 8'b0;
	
	// always_ff @(posedge clk)
	// begin
	// 	case(state) 
	// 		idle:
	// 			if(init_sig) state <= init;
	// 			else if (shuffle_sig) state <= shuffle;
	// 		init:
	// 			if(i_init > 8'hFE) state <= finish;
	// 		shuffle:
	// 			if(i_shuffle > 8'hFE) 
	// 		finish:
	// 			state <= idle;

	// 	endcase
	// end


	// always_ff @(posedge clk) 
	// begin
	// 	if (init_write)
	// 	begin			
	// 		i_init = i_init + 1;			
	// 	end
	// end

	// always_ff @(posedge clk) 
	// begin
	// 	if (shuffle_write)
	// 	begin
	// 		reg[8:0] key_index = i_shuffle % 2'd3;

	// 		j = j + s_mem_out_shuffle_i + key[key_index];

	// 		s_mem_out_shuffle_j;

	// 		i_shuffle = i_shuffle + 1 			
	// 	end
	// end

	// s_memory
	// s_memory_insta(
	// .address(i_init),
	// .clock(clk),
	// .data(i_init),
	// .wren(init_write),
	// .q(s_mem_out_init)
	// );	

	// s_memory
	// s_memory_insta(
	// .address(i_shuffle),
	// .clock(clk),
	// .data(i_shuffle),
	// .wren(0),
	// .q(s_mem_out_shuffle_i)
	// );	

	// s_memory
	// s_memory_insta(
	// .address(j),
	// .clock(clk),
	// .data(i_shuffle),
	// .wren(0),
	// .q(s_mem_out_shuffle_j)
	// );	

	// s_memory
	// s_memory_insta(
	// .address(i_shuffle),
	// .clock(clk),
	// .data(s_mem_out_shuffle_j),
	// .wren(shuffle_sig),
	// .q()
	// );	

	// s_memory
	// s_memory_insta(
	// .address(j),
	// .clock(clk),
	// .data(s_mem_out_shuffle_i),
	// .wren(shuffle_sig),
	// .q()
	// );
	
//endmodule