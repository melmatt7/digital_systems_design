module compute(
    //inputs
	 clk, start, rom_data, q,
    //outputs
    data, address, wren, rom_addr, data_decrypt, address_decrypt, wren_decrypt, complete
);

input clk, start;
input[7:0] rom_data;
input[7:0] q;

output reg[7:0] data;
output reg[7:0] address;
output wren;

output reg[4:0] rom_addr;

output reg[7:0] data_decrypt;
output reg[7:0] address_decrypt;
output wren_decrypt;

output complete;

reg[7:0] decrypted_msg = 8'b0;

reg[7:0] j = 8'b0;
reg[7:0] i = 8'b0;
reg[4:0] k = 5'b0;

reg[7:0] q_si = 8'b0;
reg[7:0] q_sj = 8'b0;
reg[7:0] f = 8'b0;

reg[1:0] data_select;
reg[1:0] address_select;

assign address_decrypt = k;
assign rom_addr = k;
assign data_decrypt = f ^ rom_data;
                             //DCBA_9_8_7_6_54_32_10
parameter idle           = 14'b0000_0_0_0_0_00_00_00;
parameter incr_i         = 14'b0001_0_0_0_0_00_00_00;
parameter addr_si        = 14'b0010_0_0_0_0_00_00_00;
parameter read_si        = 14'b0011_0_0_1_0_00_00_00;
parameter calc_j         = 14'b0100_0_0_0_0_00_00_00;
parameter addr_sj        = 14'b0101_0_0_0_0_01_00_00;
parameter read_sj        = 14'b0110_0_1_0_0_00_00_00;
parameter swap_si        = 14'b0111_0_0_0_0_01_00_10;
parameter swap_sj        = 14'b1000_0_0_0_0_00_01_10;
parameter addr_sum       = 14'b1010_0_0_0_0_11_00_00;
parameter read_sum       = 14'b1011_1_0_0_0_00_00_00;
parameter write_decrypt  = 14'b1100_0_0_0_0_10_11_01;
parameter check_k        = 14'b1101_0_0_0_0_00_00_00;
parameter incr_k         = 14'b1110_0_0_0_0_00_00_00;
parameter finish         = 14'b1111_0_0_0_1_00_00_00;

reg[13:0] state           = idle;

assign wren_decrypt = state[0];
assign wren = state[1];
assign data_select = state[3:2];
assign address_select = state[5:4];

always_comb
begin
    case(data_select)
        2'b00: data = q_si;
        2'b01: data = q_sj;
        2'b11: data = decrypted_msg;
		default: data = 8'b0;
    endcase
end

always_comb
begin
    case(address_select)
        2'b00: address = i;
        2'b01: address = j;
        2'b11: address = q_sj + q_si;
        2'b10: address = k;
    endcase
end

assign complete = state[6];

assign read_i_en = state[7];
assign read_j_en = state[8];
assign read_sum_en = state[9];

always_ff @(posedge clk)
begin
    case(state)
    idle:
        if(start) state <= incr_i;
    incr_i:
        state <= addr_si;
    addr_si:
        state <= read_si;
    read_si:
        state <= calc_j;
    calc_j:
        state <= addr_sj;
    addr_sj:
        state <= read_sj;
    read_sj:
        state <= swap_si;
    swap_si:
        state <= swap_sj;
    swap_sj:
        state <= addr_sum;
    addr_sum:
        state <= read_sum;
    read_sum:
        state <= write_decrypt;
    write_decrypt:
        state <= check_k;
    check_k:
        if(k == 8'd31) state <= finish;
        else state <= incr_k;
    incr_k:
        state <= incr_i;
    finish:
        state <= idle;
    endcase    
end

always_ff @(posedge clk)
begin
    case(state)
        incr_i: i <= i + 8'b1;
        finish: i <= 8'b0;
    endcase
end

always_ff @(posedge clk)
begin
    if(read_i_en) q_si <= q;
end

always_ff @(posedge clk)
begin
    case(state)
        calc_j: j <= j + q_si;
        finish: j <= 8'b0;
    endcase
end

always_ff @(posedge clk)
begin
    if(read_j_en) q_sj <= q;
end

always_ff @(posedge clk)
begin
    if(read_sum_en) f <= q;
end

always_ff @(posedge clk)
begin
    case(state)
        incr_k: k <= k + 5'b1;
        finish: k <= 5'b0;
    endcase
end

endmodule