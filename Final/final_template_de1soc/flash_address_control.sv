`default_nettype none
module Flash_Address_Control (//input
							  clk, sync_clk, start, readComplete, phonemeData, start_addr, end_addr, pico_recieved,
							  //output 
							  start_read_flash, read, addr, outData, byteEnable, complete, volume);
										
	input clk, sync_clk, start, readComplete, pico_recieved;
	input [31:0] phonemeData;
	input [23:0] start_addr;
	input [23:0] end_addr;
	output start_read_flash, read, complete, volume;
	output reg[23:0] byteEnable;
	output reg[22:0] addr;
	output reg[7:0] outData;
	
	reg [23:0] start_addr_word;
	reg [23:0] end_addr_word;
	
	assign byteEnable = 4'b1111;
	
	reg[5:0] state 			  = 6'b0000_00;						
								 //6543_210
	parameter idle       	  = 6'b0000_00;
	parameter read_flash      = 6'b0001_10;
	parameter wait_data_0     = 6'b0010_00;
	parameter out_data_0      = 6'b0011_00;
	parameter wait_data_1     = 6'b0100_00;
	parameter out_data_1      = 6'b0101_00;
	parameter wait_data_2     = 6'b0110_00;
	parameter out_data_2      = 6'b0111_00;
	parameter wait_data_3     = 6'b1000_00;
	parameter out_data_3      = 6'b1001_00;
	parameter inc_addr        = 6'b1010_00;
	parameter check_addr      = 6'b1011_00;
	parameter phoneme_ready   = 6'b1100_01;
	parameter finished        = 6'b1101_00;
	
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
				if (!sync_clk) state <= out_data_0;
			end 
			out_data_0: begin
				if (sync_clk) state <= wait_data_1;
			end
			wait_data_1: begin 
				if (!sync_clk) state <= out_data_1;
			end 
			out_data_1: begin
				if (sync_clk) state <= wait_data_2;
			end
			wait_data_2: begin 
				if (!sync_clk) state <= out_data_2;
			end 
			out_data_2: begin
				if (sync_clk) state <= wait_data_3;
			end
			wait_data_3: begin 
				if (!sync_clk) state <= out_data_3;
			end 
			out_data_3: begin
				if (sync_clk) state <= inc_addr;
			end
			inc_addr: begin
				state <= check_addr;
			end
			check_addr: begin 
				if (addr <= end_addr_word)
					state <= read_flash;
				else 
					state <= phoneme_ready;
			end 
			phoneme_ready: begin
				if (pico_recieved) state <= finished;
			end
			finished: begin
				if (!pico_recieved) state <= idle;
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
				end_addr_word <= end_addr[23:2];
			end
		endcase
	end
	
	always_ff @(posedge clk)
	begin
		case(state)
			idle: begin
				addr <= start_addr[23:2];
			end
			inc_addr: begin 		
				addr <= addr + 23'd1;
			end 
		endcase
	end
	

	
endmodule