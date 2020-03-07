module init(
    //inputs
	clk,
	start,
    reset,
    //outputs
    data, address, wren, complete
);

input clk, start, reset;

output reg[7:0] data;
output reg[7:0] address;
output reg wren;
output complete;
                           //32_10
parameter idle          = 4'b00_00;
parameter initialize    = 4'b01_10;
parameter finish        = 4'b10_01;

reg[3:0] state = 4'b00_000;
reg[7:0] i = 8'b0;

assign wren         = state[1];
assign complete     = state[0];

assign data = i;
assign address = i;

//state machine
always_ff @(posedge clk)
begin
	  if (reset) state <= finish;
	  else
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
end

//increment i
always_ff @(posedge clk)
begin
    case(state)
        initialize: i <= i + 8'b1;
        finish: i <= 8'b0;
    endcase
end

endmodule