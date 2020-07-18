`default_nettype none
module Flash_Address_Control (//input
							  clk, sync_clk, start, readComplete, phonemeData, start_addr, end_addr,
							  //output 
							  start_read_flash, read, addr, outData, byteEnable, complete, volume);
										
	input clk, sync_clk, start, readComplete;
	input [31:0] phonemeData;
	input [23:0] start_addr;
	input [23:0] end_addr;
	output start_read_flash, read, complete, volume;
	output reg[23:0] byteEnable;
	output reg[22:0] addr;
	output reg[7:0] outData;
	
	reg [22:0] start_addr_word;
	assign start_addr_word = start_addr >> 5;
	reg [22:0] end_addr_word;
	assign end_addr_word = (end_addr + 1) >> 5;
	
	assign byteEnable = 4'b1111;
	
	reg[6:0] state 			  = 7'b0000_000;						
								 //6543_210
	parameter idle       	  = 7'b0000_000;
	parameter read_flash      = 7'b0001_010;
	parameter wait_data_0     = 7'b0010_000;
	parameter out_data_0      = 7'b0011_100;
	parameter wait_data_1     = 7'b0100_000;
	parameter out_data_1      = 7'b0101_100;
	parameter wait_data_2     = 7'b0110_000;
	parameter out_data_2      = 7'b0111_100;
	parameter wait_data_3     = 7'b1000_000;
	parameter out_data_3      = 7'b1001_100;
	parameter inc_addr        = 7'b1010_000;
	parameter finished        = 7'b1011_001;
	
	// assign volume = state[2];
	assign start_read_flash = state[1];
	assign read = state[1];
	assign complete = state[0];
	
	always_ff @(posedge clk)
	begin
		case(state)
			idle: begin 
				if (start) state <= read_flash;
			end
			read_flash: begin
				if (readComplete) state <= wait_data_0;
			end
			wait_data_0: begin 
				if (sync_clk) state <= out_data_0;
			end 
			out_data_0: begin
				state <= wait_data_1;
			end
			wait_data_1: begin 
				if (sync_clk) state <= out_data_1;
			end 
			out_data_1: begin
				state <= wait_data_2;
			end
			wait_data_2: begin 
				if (sync_clk) state <= out_data_2;
			end 
			out_data_2: begin
				state <= wait_data_3;
			end
			wait_data_3: begin 
				if (sync_clk) state <= out_data_3;
			end 
			out_data_3: begin
				state <= inc_addr;
			end
			inc_addr: begin 
				state <= finished;
			end 
			finished: begin
				state <= idle;
			end
		endcase
	end
	
	always_ff @(posedge clk)
	begin
		case(state)
			out_data_0: begin
				outData <= phonemeData[7:0];
			end
			out_data_1: begin
				outData <= phonemeData[15:8];
			end
			out_data_2: begin
				outData <= phonemeData[23:16];
			end
			out_data_3: begin
				outData <= phonemeData[31:24];
			end
		endcase
	end
	
	always_ff @(posedge clk)
	begin
		case(state)
			idle: begin
				addr <= start_addr_word
			end
		endcase
	end
	
	always_ff @(posedge clk)
	begin
		case(state)
			inc_addr: begin 		
				if (start_addr_word < end_addr_word)
					start_addr_word <= start_addr_word + 23'd1;
			end 
		endcase
	end
	

	
endmodule