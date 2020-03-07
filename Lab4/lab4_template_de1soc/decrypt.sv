module decrypt(input logic clk,
			   input logic decrypt_start,
			   input logic reset,
			   output logic decrypt_complete,
			   //init
			   output logic init_start,
			   input logic init_complete,
			   input logic [7:0] address_init,
			   input logic [7:0] data_init,
			   input logic wren_init,
			   output logic init_reset,
			   //shuffle
			   output logic shuffle_start,
			   input logic shuffle_complete,
			   input logic [7:0] address_shuffle,
			   input logic [7:0] data_shuffle,
			   input logic wren_shuffle,
			   output logic shuffle_reset,
			   //compute
			   output logic compute_start,
			   input logic compute_complete,
			   input logic [7:0] address_compute,
			   input logic [7:0] data_compute,
			   input logic wren_compute,
			   output logic compute_reset,
			   //output
			   output reg [7:0] address_out,
			   output reg [7:0] data_out,
			   output logic wren_out);

reg[6:0] state   = 7'b000_0000;	

parameter idle          = 7'b000_0000;
parameter init_begin    = 7'b001_0001;
parameter init_end      = 7'b010_0001;
parameter shuffle_begin = 7'b011_0010;
parameter shuffle_end   = 7'b100_0010;
parameter compute_begin = 7'b101_0100;
parameter compute_end   = 7'b110_0100;
parameter finish        = 7'b111_1000;

assign init_start       = state[0];
assign shuffle_start    = state[1];
assign compute_start    = state[2];
assign decrypt_complete = state[3];

always_ff @(posedge clk)
begin
	if(reset) state <= idle;
	else
	begin
		case(state) 
		idle: if (decrypt_start) state <= init_begin;

		init_begin: state <= init_end; 

		init_end: if (init_complete) state <= shuffle_begin;

		shuffle_begin: state <= shuffle_end;	

		shuffle_end: if (shuffle_complete) state <= compute_begin;

		compute_begin: state <= compute_end;

		compute_end: if (compute_complete) state <= finish;

		endcase
	end
end

always_comb
begin
	if (init_start)         begin 
							address_out = address_init;
		                    data_out = data_init;
		                    wren_out = wren_init;
							init_reset = reset;
								shuffle_reset = 0;
								 compute_reset = 0;
							end

	else if(shuffle_start)  begin
				            address_out = address_shuffle;
		                    data_out = data_shuffle;
		                    wren_out = wren_shuffle;
							shuffle_reset = reset;
							init_reset = 0;
							compute_reset = 0;
				            end

	else if(compute_start)  begin
				            address_out = address_compute;
		                    data_out = data_compute;
		                    wren_out = wren_compute;
							compute_reset = reset;
							init_reset = 0;
							shuffle_reset =0;
				            end

  	else                    begin
		                    address_out = 8'b0;
			                data_out = 8'b0;
			                wren_out = 0;
								 init_reset = 0;
								 shuffle_reset = 0;
								 compute_reset = 0;
			                end
end

// always_ff @(posedge clk)
// begin
// 	case(state)
// 	idle: if (decrypt_start) begin 
// 							 address_out <= 8'b0;
// 							 data_out <= 8'b0;
// 							 wren_out <= 1;
// 							 end

// 	init_begin:              begin
// 				             address_out <= address_init;
// 		                     data_out <= data_init;
// 		                     wren_out <= wren_init;
// 				             end
//    init_end:              begin
// 				             address_out <= address_init;
// 		                     data_out <= data_init;
// 		                     wren_out <= wren_init;
// 				             end

// 	shuffle_begin:           begin
// 				             address_out <= address_shuffle;
// 		                     data_out <= data_shuffle;
// 		                     wren_out <= wren_shuffle;
// 				             end	
// 	shuffle_end:           begin
// 				             address_out <= address_shuffle;
// 		                     data_out <= data_shuffle;
// 		                     wren_out <= wren_shuffle;
// 				             end	

// 	compute_begin:           begin
// 				             address_out <= address_compute;
// 		                     data_out <= data_compute;
// 		                     wren_out <= wren_compute;
// 				             end
// 	compute_end:           begin
// 				             address_out <= address_compute;
// 		                     data_out <= data_compute;
// 		                     wren_out <= wren_compute;
// 				             end

// 	finish:                  begin
// 		                     address_out <= 8'b0;
// 			                 data_out <= 8'b0;
// 			                 wren_out <= 1;
// 			                 end
// 	endcase
// end

endmodule