// FSM with a regular output buffer.
module regular_output_buffer_fsm
    (
	input logic clk, reset,
	input logic mem, rw, burst,
	output logic oe, we, we_me 
	);
	typedef enum logic [5 : 0]
	{
	IDLE  = 6'b000001,
	READ1 = 6'b000010,
	READ2 = 6'b000100,
	READ3 = 6'b001000,
	READ4 = 6'b010000,
	WRITE = 6'b100000	
	} state_t;
	state_t curr_state, next_state;
	logic oe_i, we_i, oe_buf_reg, we_buf_reg;
	
	// state register
	always_ff @(posedge clk or negedge reset)
	    begin
		    if(reset)
			    curr_state <= IDLE;
			else
			    curr_state <= next_state;
		end
	// output buffer
	
	always_ff @(posedge clk or negedge reset)
	    begin
		    if(reset)
			    begin
				    oe_buf_reg <= 0;
					we_buf_reg <= 0;
				end
			else
			    begin
				    oe_buf_reg <= oe_i;
					we_buf_reg <= we_i;
				end
		end
	// next - state logic
	
	always_comb
	    begin
		    unique case(1'b1)
			    curr_state[0]:  // IDLE
				    begin
					    if(mem)
						    begin
							    if(rw)
								    next_state = READ1;
								else
								    next_state = WRITE;
							end
						else
						    next_state = IDLE;
					end
				curr_state[1]:  // READ1
				    begin
					    if(burst)
						    next_state = READ2;
						else
						    next_state = IDLE;
					end
				curr_state[2]:  // READ2
				    next_state = READ3;
				curr_state[3]:  // READ3
				    next_state = READ4;
				curr_state[4]:  // READ4
				    next_state = IDLE;
				curr_state[5]:  // WRITE
				    next_state = IDLE;
			endcase					
		end
		
	// Moore output logic
	always_comb
	    begin
		    unique case(1'b1)
			    curr_state[0]:  // IDLE
				    begin
					    we_i = 0;
						oe_i = 0;
					end
				curr_state[1]:  // READ1
				    oe_i = 1;
				curr_state[2]:  // READ2
				    oe_i = 1;
				curr_state[3]:   // READ3
				    oe_i = 1;
				curr_state[4]:  // READ4
				    oe_i = 1;
				curr_state[5]:  // WRITE
				    we_i = 1;
			endcase
		end
	// output
	always_comb
	    begin
		    we = we_buf_reg;
			oe = oe_buf_reg;
		end
endmodule: regular_output_buffer_fsm