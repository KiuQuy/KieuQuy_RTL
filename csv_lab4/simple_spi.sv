// Code your design
module simple_spi
    (
    input logic serial_in, clk, rstN,
    output logic data_rdy,
    output logic [7 : 0] data
    );
	logic [2 : 0] downcount;
	logic         cntr_rstN, shift_en;
	
	// one - hot - 0 state machine encoding
	typedef enum logic [2 : 0] 
	{
	RESET = 3'b000,
	WAITE = 3'b001,
	LOAD  = 3'b010,
	READY = 3'b100
	} state_t;
	
	state_t curr_state, next_state;
	// current state logic => sequential logic
	
	always_ff @(posedge clk or negedge rstN)
	    begin
		    if(~rstN)
			    curr_state <= RESET;
			else
			    curr_state <= next_state;
		end
	// next state logic -- combination logic
	always_comb
	    begin
		    unique case (curr_state)
			    RESET:
				    next_state = WAITE;
				WAITE: 
				    if(serial_in == '0)    // start bit sensed
					    next_state = LOAD;
					else
					    next_state = WAITE;  // no start bit
				LOAD:
				    if(downcount == '0)
					    next_state = READY;   // 8 bits are loaded
					else
					    next_state = LOAD;    // keep loading
				READY:
				    next_state = WAITE;   // return to waite state
			endcase
		end
	// FSM output -- Moore architecture
	
	always_comb
	    begin
		    unique case (curr_state)
			    RESET: {cntr_rstN, shift_en, data_rdy} = 3'b000;
				WAITE: {cntr_rstN, shift_en, data_rdy} = 3'b000;
				LOAD : {cntr_rstN, shift_en, data_rdy} = 3'b110;
				READY: {cntr_rstN, shift_en, data_rdy} = 3'b001;
			endcase
		end
	// 8 bit shift register with enable, async active - low RESET
	
	always_ff @(posedge clk or negedge rstN)
	    if(!rstN)
		    data <= '0;
		else if (shift_en)
		    data <= {serial_in, data[7 : 1]};
	
	// 3 bit decrement counter with async active - low reset
	
	always_ff @(posedge clk) // sync active low reset
	    if(!cntr_rstN)
		    downcount <= '1;  // reset to full counter
		else
		    downcount <= downcount - 1; // decrement counter
endmodule: simple_spi