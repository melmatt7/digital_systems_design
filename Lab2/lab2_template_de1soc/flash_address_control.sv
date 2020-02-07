`default_nettype none
module Flash_Address_Control (//input
										clk, sync_clk, start, readComplete, direction, restart, songs 
										//output 
										start_read_flash, read, addr, out_data, complete);
	input clk, sync_clk, start, readComplete, direction, restart
	input [31:0] songs;
	output start_read_flash, read, complete;
	output [22:0] addr;
	output[7:0] out_data;
	
	reg[5:0] state;						
								        //4321_10
	parameter idle       	  = 5'b0000_00;
	parameter read_flash      = 5'b0001_10;
	parameter wait_data_1     = 5'b0010_00;
	parameter out_data_1      = 5'b0011_00;
	parameter wait_data_2     = 5'b0100_00;
	parameter out_data_2      = 5'b0101_00;
	parameter check_direction = 5'b0111_00;
	parameter dec_addr		  = 5'b1000_00;
	parameter inc_addr        = 5'b1001_00;
	parameter finished        = 5'b1010_01;
	
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
				if (direction) out_data <= songs[31:24];
            else out_data <= songs[7:0];
				state <= wait_data_2;
			end
			wait_data_2: begin
				if (sync_clk) state <= out_data_2;
				end
			out_data_2: begin
			if (direction) out_data <= songs[7:0];
            else out_data <= songs[31:24];
				state <= check_direction;
			end
			check_direction: begin 
				if (!direction) state <= dec_addr;
				else state <= inc_addr;
			end 
			dec_addr: begin
				address <= addrsss - 23'd1;
				if (address <= 0)
					address = 23'h1FFFF;
				state <= finished;
			end
			inc_addr: begin 
				address <= addrsss + 23'd1;
				if (address > 23'h1FFFF)
					address = 0;
				state <= finished;
			end 
			finished: begin
				state <= idle;
			end
		endcase
	end
	
endmodule