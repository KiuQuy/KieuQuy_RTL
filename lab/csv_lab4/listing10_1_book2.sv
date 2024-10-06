module listing10_1_book2
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
	// next state logic
	
	always_comb
	    begin
		    unique case (1'b1)
			    curr_state[0]:   // IDLE
				    begin
					    if(mem == '1)
						    begin
							    if(rw == '1)
								    next_state = READ1;
								else
								    next_state = WRITE;
							end
						else
						    next_state = IDLE;
					end
				curr_state[1]:  //READ1
				    begin
					    if(burst == '1)
						    next_state = READ2;
						else
						    next_state = IDLE;
					end
				curr_state[2]:  // READ2
					next_state = READ3;
				curr_state[3]: // READ3
				    next_state = READ4;
				curr_state[4]: // READ4
				    next_state = IDLE;
				curr_state[1]: // WRITE
				    next_state = IDLE;
			endcase
		end
	// moore output logic
	
	always_comb
	    begin
		    unique case (1'b1)
			    curr_state[0]: // IDLE
				    begin
				        we = '0;
			            oe = '0;
					end
				curr_state[1]: // READ1
				    oe = 1;
				curr_state[2]: // READ2
				    oe = 1;
				curr_state[3]: // READ3
				    oe = 1;
				curr_state[4]: // READ4
				    oe = 1;
				curr_state[5]: // WRITE
				    we = 1;
			endcase		    
		end	
	// mealy
	always_comb
	    begin
		    we_me = 0;
		    unique case (1'b1)
			    curr_state[0]: // IDLE
				    begin
				        if(mem == 1 & rw == 0)
						    we_me = 1;
					end		
			endcase
			    
		end
endmodule: listing10_1_book2