// chia thanh 2 segment: register va comb
module listing10_2_book2
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
	
	// state register
	always_ff @(posedge clk or negedge reset)
	    begin
		    if(reset)
			    curr_state <= IDLE;
			else
			    curr_state <= next_state;
		end
	// next_state and logic state
	always_comb
	    begin
		    oe = 0;
			we = 0;
			we_me = 0;
			unique case (1'b1)
			    curr_state[0]: // IDLE
				    begin
					    if(mem)
						    begin
							    if(rw)
								    next_state = READ1;
								else
								    next_state = WRITE;
									we_me      = 1;
							end
						else
						   next_state = IDLE;
					end
				curr_state[1]: // READ1
				    begin
					    oe  = 1;
					    if(burst)
						    next_state = READ2;
						else
						    next_state = IDLE;
					end
				curr_state[2]: //READ2
				    begin
					    next_state = READ3;
						oe = 1;
					end
				curr_state[3]:  // READ3
				    begin
				    next_state = READ4;
					oe = 1;
					end
				curr_state[4]:  // READ4
				    begin
				    next_state = IDLE;
					oe = 1;
					end
				curr_state[5]: //WRITE
				    begin
					    next_state = IDLE;
						we = 1;
					end
			endcase		
		end
endmodule: listing10_2_book2