`default_nettype none
module Flash_Address_Control (//input
										clk, sync_clk, start, readComplete, direction, restart, songData, 
										//output 
										start_read_flash, read, addr, outData, byteEnable, complete);
										
	input clk, sync_clk, start, readComplete, direction, restart;
	input [31:0] songData;
	output start_read_flash, read, complete;
	output[3:0] byteEnable;
	output [22:0] addr;
	output[7:0] outData;
	
	assign byteEnable = 4'b1111;
	
	reg[5:0] state = 6'b0000_00;						
								        //4321_10
	parameter idle       	  = 6'b0000_00;
	parameter read_flash      = 6'b0001_10;
	parameter wait_data_1     = 6'b0010_00;
	parameter out_data_1      = 6'b0011_00;
	parameter wait_data_2     = 6'b0100_00;
	parameter out_data_2      = 6'b0101_00;
	parameter check_direction = 6'b0110_00;
	parameter dec_addr		  = 6'b0111_00;
	parameter inc_addr        = 6'b1000_00;
	parameter finished        = 6'b1001_01;
	
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
				if (readComplete) state <= wait_data_1;
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
				state <= check_direction;
			end
			check_direction: begin 
				if (!direction) state <= dec_addr;
				else state <= inc_addr;
			end 
			dec_addr: begin
				state <= finished;
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
			out_data_1: begin
				if (!direction) outData <= songData[31:24];
				else outData <= songData[7:0];
			end
			out_data_2: begin
				if (!direction) outData <= songData[7:0];
				else outData <= songData[31:24];
			end
		endcase
	end
	
	always_ff @(posedge clk)
	begin
		case(state)
			dec_addr: begin
				addr <= addr - 23'd1;
				if (addr <= 0)
					addr <= 23'h7FFFF;
			end
			inc_addr: begin 
				addr <= addr + 23'd1;
				if (addr > 23'h7FFFF)
					addr <= 0;
			end 
		endcase
	end
	
endmodule