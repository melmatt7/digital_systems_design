module fsm (state, odd, even, terminal, pause, restart, clk, rst, goto_third, Out1, Out2);

input pause, restart, clk, rst, goto_third;

output odd, even, terminal;
reg odd, even, terminal;

output [2:0] Out1;
reg [2:0] Out1;
output [2:0] Out2;
reg [2:0] Out2;

output [8:0] state;
reg [8:0] state;
						 //Out1_Out2_Num
						  //876_543_210
parameter FIRST  = 9'b011_010_000;
parameter SECOND = 9'b101_100_001;
parameter THIRD  = 9'b010_111_010;
parameter FOURTH = 9'b110_011_011;
parameter FIFTH  = 9'b101_010_100;

always_ff @(posedge clk or posedge rst) // sequential
begin
	if (rst) state <= FIRST;
	else
	begin
		case(state)
		FIRST: 	if (restart | pause) state <= FIRST;
					else state <= SECOND;
										
		SECOND:  if (restart) state <= FIRST;
				   else if (pause) state <= SECOND;
				   else state <= THIRD;
										
		THIRD:   if (restart) state <= FIRST;
				   else if (pause) state <= THIRD;
				   else state <= FOURTH;
									
		FOURTH:  if (restart) state <= FIRST;
					else if (pause) state <= FOURTH;
				   else state <= FIFTH;
										
		FIFTH:   if (restart) state <= FIRST;
					else if (goto_third) state <= THIRD;
					else state <= FIFTH;
										
		default: state <= FIRST;
		endcase
	end
end

// output logic described using procedural assignment
always_comb
begin
	terminal = state[2] & (restart);
	even = state[0];
	odd = !state[0];
	Out1 = state[8:6];
	Out2 = state[5:3];
end

endmodule


