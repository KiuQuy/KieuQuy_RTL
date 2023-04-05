module listing10_1_book2_tb();
    logic clk, reset;
	logic mem, rw, burst;
	logic oe, we, we_me;
	
	listing10_1_book2 uut1
	//listing10_2_book2 uut2
	// regular_output_buffer_fsm uut3
	// look_ahead_output_buffer_fsm uut4
	(
	.clk(clk),
	.reset(reset),
	.mem(mem),
	.rw(rw),
	.burst(burst),
	.oe(oe),
	.we(we),
	.we_me(we_me)
	);
	
	//stimulate signal
	initial
	    begin
		    clk = 0;
			reset = 0;
			#5 reset = 1;
			#6 reset = 0;
			repeat(20)
			    begin
				    #5 {mem, rw, burst} = $random();
				end
		end
	always #5 clk = ~clk;

endmodule: listing10_1_book2_tb