module LFSR_counter_tb;
    logic clk;
	logic reset;
	logic [3 : 0] q;
	
	LFSR_counter uut
	(
	.clk(clk),
	.reset(reset),
	.q(q)
	);
	
	always #5 clk = ~clk;
	initial
	    begin
		    clk = 0;
			reset = 0;
			
			#12 reset = 1;
			#5 reset = 0;
		end
	always @(negedge clk)
	    begin
		    $monitor("time = %t; data = %b", $realtime(), q);
		end

endmodule: LFSR_counter_tb