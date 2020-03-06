module fsm(
    //inputs
	 clk, start, rom_data, q,
    //outputs
    data, address, wren, rom_addr, complete
);

input clk, start;
input[7:0] rom_data;
input[7:0] q;

output[7:0] data;
output[7:0] address;
output wren;
output[7:0] rom_addr;
output complete;

reg[7:0] decrypted_msg;
reg[7:0] encrypted_msg;

reg[7:0] j = 8'b0;
reg[7:0] i = 8'b0;
reg[7:0] k = 8'b0;
reg[7:0] sum = 8'b0;

reg[7:0] q_si;
reg[7:0] q_sj;
reg[7:0] f;

reg[1:0] data_select;
reg[1:0] address_select;

assign rom_addr = k;
assign encrypted_msg = rom_data;
assign decrypted_msg = f ^ encrypted_msg;
                             //DCBA9_8_7_6_5_4_3_2_1_0
parameter idle           = 14'b00000_0_0_0_0_00_00_0;
parameter incr_i         = 14'b00001_0_0_0_0_00_00_0;
parameter addr_si        = 14'b00010_0_0_0_0_00_00_0;
parameter read_si        = 14'b00011_0_0_1_0_00_00_0;
parameter calc_j         = 14'b00100_0_0_0_0_00_00_0;
parameter addr_sj        = 14'b00101_0_0_0_0_01_00_0;
parameter read_sj        = 14'b00110_0_1_0_0_00_00_0;
parameter swap_si        = 14'b00111_0_0_0_0_01_00_1;
parameter swap_sj        = 14'b01000_0_0_0_0_00_01_1;
parameter calc_sum       = 14'b01001_0_0_0_0_00_00_0;
parameter addr_sum       = 14'b01010_0_0_0_0_10_00_0;
parameter read_sum       = 14'b01011_1_0_0_0_00_00_0;
parameter x_or           = 14'b01100_0_0_0_0_00_00_0;
parameter write_decrypt  = 14'b01101_0_0_0_0_11_10_1;
parameter check_k        = 14'b01110_0_0_0_0_00_00_0;
parameter incr_k         = 14'b01111_0_0_0_0_00_00_0;
parameter finish         = 14'b10000_0_0_0_1_00_00_0;

reg[13:0] state           = idle;

assign wren = state[0];
assign data_select = state[2:1];
assign address_select = state[4:3];

always_comb
begin
    case(data_select)
        2'b00: data = q_si;
        2'b01: data = q_sj;
        2'b10: data = decrypted_msg;
		default: data = 8'b0;
    endcase
end

always_comb
begin
    case(address_select)
        2'b00: address = i;
        2'b01: address = j;
        2'b10: address = sum;
        2'b11: address = k;
    endcase
end

assign complete = state[5];

assign read_i_en = state[6];
assign read_j_en = state[7];
assign read_sum_en = state[8];

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
        state <= calc_sum;
    calc_sum:
        state <= addr_sum;
    addr_sum:
        state <= read_sum;
    read_sum:
        state <= x_or;
    x_or:
        state <= write_decrypt;
    write_decrypt:
        state <= check_k;
    check_k:
        if(k == 5'd31) state <= finish;
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
    case(state)
        calc_sum: sum <= q_sj + q_si;
        finish: sum <= 8'b0;
    endcase
end

always_ff @(posedge clk)
begin
    if(read_sum_en) f <= q;
end

always_ff @(posedge clk)
begin
    case(state)
        incr_k: k <= k + 5'b1;
        finish: k <= 8'b0;
    endcase
end

endmodule