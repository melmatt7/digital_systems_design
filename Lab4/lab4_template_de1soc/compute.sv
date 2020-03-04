module compute(
    //inputs
	 clk, start,
    //outputs
    data, address, wren, complete
);

input clk, start;

output [7:0] data;
output [7:0] address;
output wren;
output complete;

endmodule