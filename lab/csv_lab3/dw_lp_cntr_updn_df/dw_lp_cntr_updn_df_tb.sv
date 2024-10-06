module dw_lp_cntr_updn_df_tb;
    parameter WIDTH = 4;
	logic                  clk;
	logic                  rst_n;
	logic                  enable;
	logic                  up_dn;
	logic                  ld_n;
	logic [WIDTH - 1 : 0]  ld_count;
	logic [WIDTH - 1 : 0]  term_val;
	
	//
	logic [WIDTH - 1 : 0]  count;
	logic                  term_count_n;
	
	//instantiate module
	dw_lp_cntr_updn_df 
	#(.WIDTH(WIDTH))
	uut
	(
	.clk(clk),
	.rst_n(rst_n),
	.enable(enable),
	.up_dn(up_dn),
	.ld_n(ld_n),
	.ld_count(ld_count),
	.term_val(term_val),
	.count(count),
	.term_count_n(term_count_n)
	);
	
	initial
	    begin
		    clk = 0;
			// Functional operation: Reset, Load, Count to Sequence
			rst_n = 1;
			enable = 0;
			up_dn  = 1;
			term_val = 4;
			#2  rst_n = 0;
			#4  rst_n = 1;
			    ld_n  = 0;
                ld_count = 0;
            # 60 enable = 1;
            // Functional operation: Up and down counting, and Count to Sequence
            #20 rst_n = 1;
                ld_n  = 1;
                enable = 1;
             	ld_count = 0;
            #60 up_dn = 0;				
		end
	always #5 clk = ~clk;
endmodule: dw_lp_cntr_updn_df_tb