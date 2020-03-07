module brute_force(	//inputs
					clk,
					start,
					decrypt_msg_data,
					wren_start,
					compute_complete,
					//outputs
					LED_sel,
					start_decrypt,
					reset_decrypt,
					secret_key,
					HEX_out							
				  );
input clk, start, wren_start;
input [7:0] decrypt_msg_data;
input logic compute_complete;

output start_decrypt;
output reset_decrypt;
output LED_sel;
output reg[23:0] secret_key;
output reg[23:0] HEX_out;

reg[23:0] key = 24'b0;
reg[1:0]  LED_sel = 2'b0;

assign HEX_out = key;
assign secret_key = key;
                               //7654_3_2_10
parameter idle				= 8'b0000_0_0_00;
parameter begin_decrypt	= 8'b0001_0_1_00;
parameter wait_compute	= 8'b0010_0_0_00;
parameter verify_val		= 8'b0011_0_0_00;
parameter decrypt_reset	= 8'b0100_1_0_00;
parameter check_key 		= 8'b0101_0_0_00;
parameter incr_key		= 8'b0110_0_0_00;
parameter failure			= 8'b0111_0_0_01;
parameter success			= 8'b1000_0_0_11;

reg[7:0] state = idle;

assign LED_sel = state[1];

assign start_decrypt = state[2];
assign reset_decrypt = state[3];

always_ff @(posedge clk)
begin
    case(state)
    idle:
        if(start) state <= begin_decrypt;
    begin_decrypt:
        state <= wait_compute;
    wait_compute:
		  if (compute_complete) state <= success;

        else if(wren_start) state <= verify_val;
    verify_val: begin
					 if ((decrypt_msg_data >= 97 && decrypt_msg_data <= 122) ||	decrypt_msg_data == 32) begin 
						if (compute_complete) state <= success;
						else state <= wait_compute;
					 end
					 else state <= decrypt_reset;
		          end
		
    decrypt_reset:
        state <= check_key;
	check_key:
		if (key == 24'hFFFFFF) state <= failure;
		else state <= incr_key;
	incr_key:
		state <= begin_decrypt;
    endcase    
end

always_ff @(posedge clk)
begin
    case(state)
        incr_key: key <= key + 24'b1;
	endcase
end

endmodule