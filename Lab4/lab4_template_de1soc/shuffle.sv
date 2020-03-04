module shuffle(//inputs
				input logic clk,
			   input logic [23:0] key,
			   input logic start,
			   input logic [7:0] q,
			   	//outputs
			   output reg[7:0] data,
			   output reg[7:0] address,
			   output logic wren,
			   output reg[7:0] complete
			  );
			  
	reg[4:0] state   = 5'b0000_0;						
	reg[1:0] key_index = 2'b00;
	reg[7:0] j = 8'b0;
	reg[7:0] i = 8'b0;

	reg[7:0] q_si = 8'b0;
	reg[7:0] q_sj = 8'b0;

	parameter idle     = 5'b0000_0;
	parameter read_i   = 5'b0001_0;
	parameter calc_j   = 5'b0010_0;
	parameter read_j   = 5'b0011_0;
	parameter swap_i   = 5'b0100_0;
	parameter swap_j   = 5'b0101_0;
	parameter check_i  = 5'b0110_0;
	parameter incr_i   = 5'b0111_0;
	parameter finish   = 5'b1000_1;

	always_ff @(posedge clk)
	begin
		case(state) 
			idle:
				if(start) state <= read_i;
			read_i:
				state <= calc_j;
			calc_j:
				state <= read_j;
			read_j:
				state <= swap_i;
			swap_i:
				state <= swap_j;
			swap_j:
				state <= check_i;
			check_i:
				if(i > 8'hFE) state <= finish;
				else state <= incr_i;
			incr_i:
				state <= read_i;
			finish:
				state <= idle;
		endcase
	end

	always_ff @(posedge clk)
	begin
		if(state == calc_j) begin
			j = j + q_si + key[i % 2'b11];
		end
	end
	
	always_ff @(posedge clk)
	begin
		case(state)
			read_i: begin
				address = i;
				data = 8'b0;
				wren = 0;

				q_si = q;
				q_sj = q_sj;
			end
			read_j: begin
				address = j;
				data = 8'b0;
				wren = 0;

				q_sj = q;
				q_si = q_si;
			end
			swap_i: begin
				address = i;
				data = q_sj;
				wren = 1;
				
				q_si = q_si;
				q_sj = q_sj;
			end
			swap_j: begin
				address = j;
				data = q_si;
				wren = 1;
				
				q_si = q_si;
				q_sj = q_sj;
			end
		endcase
	end

	always_ff @(posedge clk)
	begin
		if(state == incr_i) begin
			i = i + 8'b1;
		end
	end
	
endmodule
	