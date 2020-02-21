`default_nettype none
module Flash_Address_Control (//input
										clk, sync_clk, start, readComplete, direction, restart, songData, 
										//output 
										start_read_flash, read, addr, outData, byteEnable, complete, volume);
										
	input clk, sync_clk, start, readComplete, direction, restart;
	input [31:0] songData;
	output start_read_flash, read, complete, volume;
	output[3:0] byteEnable;
	output [22:0] addr;
	output[7:0] outData;
	
	parameter last_addr = 23'h7FFFF;
	parameter first_addr = 23'd0;
	
	assign byteEnable = 4'b1111;
	
	reg[5:0] state = 6'b0000_00;						
								        //5432_10
	parameter idle       	  = 6'b0000_000;
	parameter read_flash      = 6'b0001_010;
	parameter wait_data_1     = 6'b0010_000;
	parameter out_data_1      = 6'b0011_100;
	parameter wait_data_2     = 6'b0100_000;
	parameter out_data_2      = 6'b0101_100;
	parameter check_direction = 6'b0110_000;
	parameter dec_addr		  = 6'b0111_000;
	parameter inc_addr        = 6'b1000_000;
	parameter finished        = 6'b1001_001;
	
	assign volume = state[2];
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
				if(restart)
					addr <= last_addr;
				else begin
					addr <= addr - 23'd1;
					if (addr <= first_addr)
						addr <= last_addr;
				end
			end
			inc_addr: begin 
				if(restart)
					addr <= first_addr;
				else begin
					addr <= addr + 23'd1;
					if (addr > last_addr)
						addr <= first_addr;
				end
			end 
		endcase
	end
	
endmodule