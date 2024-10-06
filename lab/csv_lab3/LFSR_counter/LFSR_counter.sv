module LFSR_counter
    (
	input logic clk,
	input logic reset,
	
	output logic [3 : 0] q
	);
	
	logic [3 : 0] r_reg, r_next;
	logic          fb;
	// register
	always_ff @(posedge clk or negedge reset)
	    begin
		    if(reset) r_reg <= 1;
			else r_reg <= r_next;
		end	
	// next state logic
	always_comb
	    begin
		    fb     = r_reg[1] ^ r_reg [0];
			r_next = {fb, r_reg [3 : 1]};
		end
	// output logic
	assign q = r_reg;

endmodule: LFSR_counter