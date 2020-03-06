module compute(
    //inputs
	 clk, start, encrypted_msg,
    //outputs
    data, address, wren, complete, decrypted_msg
);

input clk, start;
input [7:0] encrypted_msg;

output [7:0] data;
output [7:0] address;
output [7:0] decrypted_msg
output wren;
output complete;

reg[7:0] j = 8'b0;
reg[7:0] i = 8'b0;
reg[5:0] k = 6'b0;
reg[7:0] f;


reg[7:0] q_si;
reg[7:0] q_sj;


reg[7:0] state = 8'b0000_0000;

parameter idle = 8'b0000_0000;
parameter incr_i;
parameter read_si = ;
parameter calc_j = ;
parameter read_sj = ;
parameter swap_si = ;
parameter swap_sj = ;
parameter calc_f = ;
parameter decrypt_output = ;
parameter incr_k = ;
parameter check_k = ;
parameter finish = ;



always_ff @(posedge clk)
begin
    case(state)
    idle:
        if(start) state <= incr_i;
    incr_i:
        state <= read_si;
    read_si:
        state <= calc_j;
    calc_j:
        state <= read_sj;
    read_sj:
        state <= swap_si;
    swap_si:
        state <= swap_sj;
    swap_sj:
        state <= calc_f;
    calc_f:
        state <= decrypt_output;
    check_k:
        if(k > 6'd31) state <= finish;
        else state <= incr_k;
    incr_k:
        state <= incr_i;
    finish:
        state <= idle;
    endcase
    
end

endmodule