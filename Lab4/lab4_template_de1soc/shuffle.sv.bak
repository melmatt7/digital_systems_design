module shuffle(//inputs
			   input logic key
			   input logic start
			   input logic [7:0] q
			   	//outputs
			   output logic reg[7:0] data
			   output logic reg[7:0] address
			   output logic wren
			   output logic reg[7:0] complete
			  );
	reg[8:0] key_index = i_shuffle % 2'd3;
	reg[1:0] state   = 2'b0_00;						

	reg[7:0] j = 8'b0;
	reg[7:0] i = 8'b0;

	reg[7:0] q_si = 8'b0;
	reg[7:0] q_sj = 8'b0;

	parameter idle     = 4'b0000_0;
	parameter read_i   = 4'b0001_0;
	parameter calc_j   = 4'b0010_0;
	parameter read_j   = 4'b0011_0;
	parameter swap_i   = 4'b0100_0;
	parameter swap_j   = 4'b0101_0;
	parameter check_i  = 4'b0110_0;
	parameter incr_i   = 4'b0111_0;
	parameter complete = 4'b1000_1;

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
				if(i > 8'hFE) state <= complete;
				else state <= incr_i;
			incr_i:
				state <= read_i;
			complete:
				state <= idle;
		endcase
	end

	always_ff @(posedge clk)
	begin
		if(state == read_i) begin
			address_out <= i;
			data_out <= 0'b0;
			wren_out <= 0;

			q_si <= q;
		end
	end

	always_ff @(posedge clk)
	begin
		if(state == calc_j) begin
			j = j + s_mem_out_shuffle_i + key[key_index];
		end
	end

	always_ff @(posedge clk)
	begin
		if(state == read_j) begin
			address_out <= j;
			data_out <= 0'b0;
			wren_out <= 0;

			q_ji <= q;
		end
	end

	always_ff @(posedge clk)
	begin
		if(state == swap_i) begin
			address_out <= i;
			data_out <= q_sj;
			wren_out <= 1;
		end
	end

	always_ff @(posedge clk)
	begin
		if(state == swap_j) begin
			address_out <= j;
			data_out <= q_si;
			wren_out <= 1;
		end
	end

	always_ff @(posedge clk)
	begin
		if(state == incr_i) begin
			i = i + 8'b1;
		end
	end
	
endmodule
	