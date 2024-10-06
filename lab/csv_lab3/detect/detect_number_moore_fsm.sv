module detect_number_fsm
    (
	input clk, rst_n,
	input valid, data_in,
	output logic found
	);
	typedef enum logic [5 : 0]
	{
	IDLE    = 6'b000_001,
	S_1     = 6'b000_010,
	S_11    = 6'b000_100,
	S_110   = 6'b001_000,
	S_1101  = 6'b010_000,
	S_11011 = 6'b100_000
	} state_t;
	state_t curr_state, next_state;
	//chuyen trang thai
	always_ff @ (posedge clk or negedge rst_n)
	    begin
		    if(!rst_n)
			    curr_state <= IDLE;
			else
			    curr_state <= next_state;
		end
	// comb next state logic
	always_comb
	    begin
		    unique case(1'b1)
			    // IDLE
			    curr_state[0]: 
				    begin
					    if(valid) next_state = data_in ? S_1 : IDLE;
						else      next_state = IDLE;  
					end
				// S_1
			    curr_state[1]:
				    begin
					    if(valid) next_state = data_in ? S_11 : IDLE;
						else      next_state = S_1;	
					end
				// S_11
			    curr_state[2]:
				    begin
					    if(valid) next_state = data_in ?  S_11 : S_110;
						else      next_state = S_11;
					end
				// S_110
			    curr_state[3]:
				    begin
					    if(valid) next_state = data_in ? S_1101 : IDLE;
						else      next_state = S_110;
					end
				// S_1101
			    curr_state[4]:
				    begin
					    if(valid) next_state = data_in ? S_11011 : IDLE;
						else      next_state = S_1101;
					end
				// S_11011
			    curr_state[5]:
				    begin
					    if(valid) next_state = data_in ? S_11 : S_110;
						else      next_state = S_11011;
					end	
			endcase
		end
	// output logic block
	always_comb
	    begin
		    found = (curr_state == S_11011) ? 1 : 0;
		end
endmodule: detect_number_fsm
/*
hello
*/