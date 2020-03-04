module init(
    //inputs
	start,
    //outputs
    data, address, wren, complete
);

input start;

output [7:0] data;
output [7:0] address;
output wren;
output complete;
                           //43_21
parameter idle          = 5'b00_000;
parameter initialize    = 5'b01_110;
parameter finish        = 5'b10_001;

reg[4:0] state = 5'b00_000;
reg[7:0] i = 8'b0;

assign wren         = state[2];
assign init_write   = state[1];
assign complete     = state[0];

//state machine
always_ff @(posedge clk)
begin
    case(state)
        idle:
            if(start)   state <= initialize;    
        initialize:
            if(i > 8'hFE)   state <= finish;
        finish:
            state <= idle;
    endcase
end

//increment i
always_ff @(posedge clk)
begin
    if(init_write)
    begin
        i = i + 1;
    end
end

//assign data and address as i
always_comb
begin
    data = i[7:0];
    address = i[7:0];
end

endmodule