module shared_access_to_one_state_machine#(parameter N = 32, parameter M = 8)
										  (output reg [(N-1):0] output_arguments,
										   output start_target_state_machine,
										   input target_state_machine_finished,
										   input sm_clk,
										   input logic start_request_a,
										   input logic start_request_b,
										   output logic finish_a,
										   output logic finish_b,
										   output logic reset_start_request_a,
										   output logic reset_start_request_b,
										   input [(N-1):0] input_arguments_a,
										   input [(N-1):0] input_arguments_b,
										   output reg [(M-1):0] received_data_a,
										   output reg [(M-1):0] received_data_b,
										   input reset,
										   input [M-1:0] in_received_data,
											output reg [11:0] state);
											   
	                              //BA98_7654_3210
	parameter check_start_a      = 12'b0000_0000_0000;
	parameter give_start_a       = 12'b0001_0110_0000;
	parameter wait_for_finish_a  = 12'b0010_0000_0000;
	parameter register_data_a    = 12'b0011_0000_0010;
	parameter give_finish_a      = 12'b0100_0000_1000;
	parameter check_start_b      = 12'b0101_1000_0000;
	parameter give_start_b       = 12'b0110_1101_0000;
	parameter wait_for_finish_b  = 12'b0111_1000_0000;
	parameter register_data_b    = 12'b1000_1000_0001;
	parameter give_finish_b      = 12'b1001_1000_0100;
	
	assign select_b_output_parameters = state[7];
	assign start_target_state_machine = state[6];
	assign reset_start_request_a = state[5];
	assign reset_start_request_b = state[4];
	assign finish_a = state[3];
	assign finish_b = state[2];
	assign register_data_a_enable = state[1];
	assign register_data_b_enable = state[0];

	always @(posedge sm_clk or posedge reset)
	begin
		if(reset) state <= check_start_a;
		else 
		begin
			case(state)
			check_start_a:
				if (start_request_a) state <= give_start_a;
				else state <= check_start_b;   
			give_start_a:
				state <= wait_for_finish_a;   
			wait_for_finish_a:
				if(target_state_machine_finished) state <= register_data_a;
			register_data_a: 
				state <= give_finish_a;
			give_finish_a:
				state <= check_start_b;    
			check_start_b:
				if (start_request_b) state <= give_start_b;
				else state <= check_start_a;    
			give_start_b: 
				state <= wait_for_finish_b; 
			wait_for_finish_b:
				if(target_state_machine_finished) state <= register_data_b;
			register_data_b:
				state <= give_finish_b;
			give_finish_b:   
				state <= check_start_a;
			default:
				state <= check_start_a;
			endcase
		end
	end

	always @(posedge sm_clk or posedge reset)
	begin
		if (reset)
			received_data_a <= 0;
		else if (register_data_a_enable)
			received_data_a <= in_received_data;
	end

	always @(posedge sm_clk, posedge reset)
	begin
		if (reset)
			received_data_b <= 0;
		else if (register_data_b_enable)
			received_data_b <= in_received_data;
	end

	always_comb 
	begin	
		if (select_b_output_parameters)
			output_arguments = input_arguments_b;
		else
			output_arguments = input_arguments_a;
	end
														
endmodule