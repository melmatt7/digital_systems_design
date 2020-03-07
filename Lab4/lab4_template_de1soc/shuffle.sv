module shuffle(//inputs
			   input logic clk,
			   input logic [23:0] key,
			   input logic reset,
			   input logic start,
			   input logic [7:0] q,
			   	//outputs
			   output reg[7:0] data,
			   output reg[7:0] address,
			   output logic wren,
			   output logic complete
			  );				
	reg[7:0] key_val = 8'b0;
	reg[7:0] j = 8'b0;
	reg[7:0] i = 8'b0;

	reg[7:0] q_si = 8'b0;
	reg[7:0] q_sj = 8'b0;
						   //9876_5_4_3_2_1_0	
	parameter idle     = 10'b0000_0_0_0_0_0_0;
	parameter addr_i   = 10'b0001_0_0_0_1_0_0;
	parameter read_i   = 10'b0010_0_1_0_0_0_0;
	parameter calc_j   = 10'b0011_0_0_0_0_0_0;
	parameter addr_j   = 10'b0100_0_0_0_0_0_0;
	parameter read_j   = 10'b0101_1_0_0_0_0_0;
	parameter swap_i   = 10'b0111_0_0_0_1_0_1;
	parameter swap_j   = 10'b1000_0_0_0_0_1_1;
	parameter check_i  = 10'b1001_0_0_0_0_0_0;
	parameter incr_i   = 10'b1010_0_0_0_0_0_0;
	parameter finish   = 10'b1011_0_0_1_0_0_0;
	
	reg[9:0] state   = idle;

	assign wren = state[0];
	assign data = state[1] ? q_si : q_sj;
	assign address = state[2] ? i : j;
	assign complete = state[3];

	assign read_i_en = state[4];
	assign read_j_en = state[5];

	always_ff @(posedge clk)
	begin
		if(reset) state <= finish;
		else 
		begin
			case(state) 
				idle:
					if(start) state <= addr_i;
				addr_i:
					state <= read_i;
				read_i:
					state <= calc_j;
				calc_j:
					state <= addr_j;
				addr_j:
					state <= read_j;
				read_j:
					state <= swap_i;
				swap_i:
					state <= swap_j;
				swap_j:
					state <= check_i;
				check_i:
					if(i == 8'hFF) state <= finish;
					else state <= incr_i;
				incr_i:
					state <= addr_i;
				finish:
					state <= idle;
				// default:
				// 	state <= idle;
			endcase
		end
	end

	always_ff @(posedge clk)
	begin
		case(state)
			calc_j: j <= j + q_si + key_val;
			finish: j <= 8'b0;
		endcase
	end
	
	always_ff @(posedge clk)
	begin
		if(read_i_en) q_si <= q;
	end

	always_ff @(posedge clk)
	begin
		if(read_j_en) q_sj <= q;
	end
	
	always_ff @(posedge clk)
	begin
		case(state)
			incr_i: i <= i + 8'b1;
			finish: i <= 8'b0;
		endcase
	end
	
	always_comb
	begin
		case(i % 2'd3)
			2'd0: key_val = key[23:16];
			2'd1: key_val = key[15:8];
			2'd2: key_val = key[7:0];
			default: key_val = 8'b0;
		endcase
	end

endmodule
	