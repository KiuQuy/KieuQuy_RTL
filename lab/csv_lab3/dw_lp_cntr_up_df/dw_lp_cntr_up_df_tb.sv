module dw_lp_cntr_up_df_tb;
    parameter WIDTH = 4;
	//input of dut
	logic                  clk;
	logic                  rst_n;
	logic                  enable;
	logic                  ld_n;
	logic [WIDTH - 1 : 0]  ld_count;
	logic [WIDTH - 1 : 0]  term_val;
	
	// output of dut
	logic                  term_count_n;
	logic [WIDTH - 1 : 0]  count;
	
	//instantiate uut
	dw_lp_cntr_up_df 
	#(
	.WIDTH(WIDTH)
	) uut
	(
	.clk(clk),
	.rst_n(rst_n),
	.enable(enable),
	.ld_n(ld_n),
	.ld_count(ld_count),
	.term_val(term_val),
	.term_count_n(term_count_n),
	.count(count)
	);
	initial
	    begin
		    clk = 0;
			//Reset, Load, and Count to Sequence
			rst_n = 1;
			ld_n  = 1;
			enable = 0;
			term_val = 4;
			#3 rst_n = 0;
			#6 rst_n = 1;
			   ld_n  = 0;
			   ld_count = 0;
			#30 ld_n  = 1;
			#10 enable = 1;	
		end
	always #5 clk = ~clk;

endmodule: dw_lp_cntr_up_df_tb