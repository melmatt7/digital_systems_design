`default_nettype none
module lfsr(//input
            clk,
            reset,
				//output
				lfsr_out
            );
    input clk, reset;

    output reg[4:0] lfsr_out = 5'b00001;

    wire feedback;

    always_comb
    begin
        feedback = lfsr_out[0] ^ lfsr_out[2];
    end
	
	always_ff @(posedge clk)
    begin
        if (reset) lfsr_out <= 5'b00001;
        else lfsr_out <= {feedback, lfsr_out[4:1]};
    end

endmodule
