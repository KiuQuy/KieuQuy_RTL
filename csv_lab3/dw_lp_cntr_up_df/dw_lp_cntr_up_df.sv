module dw_lp_cntr_up_df
    #(
	parameter WIDTH = 4
	)
	(
	input                         clk,
	input                         rst_n,
	input                         enable,
	input                         ld_n,
	input [WIDTH - 1 : 0]         ld_count,
	input [WIDTH - 1 : 0]         term_val,
    // output
    output  logic                 term_count_n,
    output  logic [WIDTH - 1 : 0] count	
	);
	
	logic [WIDTH - 1 : 0] count_nx;
	
	always_ff @(posedge clk or negedge rst_n)
	    begin
		    if(!rst_n)    // 1st
			    count <= 0;
			else 
			    count <= count_nx;
		end
    always_comb
	    begin
		    if(!ld_n)
			    count_nx = ld_count;
			else if(!enable)
			    count_nx = count;
			else
			    count_nx = count + 1;
		end
	always_comb
	    begin
		    term_count_n = (count == term_val) ? 0 : 1;
		end
endmodule: dw_lp_cntr_up_df