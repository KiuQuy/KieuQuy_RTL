module dw_lp_cntr_updn_df
    #(
	parameter WIDTH = 4
	)
    (
	input                  clk,
	input                  rst_n,
	input                  enable,
	input                  up_dn,    //up versus down control input (1 = up, 0 = down)
	
	
	input                  ld_n,     //counter load control - active low, enable load ld_count
	input  [WIDTH - 1 : 0] ld_count, //counter load value
	
	
	input  [WIDTH - 1 : 0] term_val, //terminal count value
	
	output logic [WIDTH - 1 : 0] count,
	output logic                 term_count_n  // terminal count          
	);
    // cnt nx
	logic [WIDTH - 1 : 0] count_nx;
	always_comb
	    begin
		    if(!ld_n)    // 2'st priority
			    count_nx = ld_count;
			else if (enable)    // 3
			    begin
				    if(up_dn)   //4
					    count_nx = count + 1;
					else      
					    count_nx = count - 1;
				end
			else 
			    count_nx = count;
            			
		end
	always_ff @ (posedge clk or negedge rst_n)
	    begin
		    if(~rst_n)   // 1'st 
			    count <= 0;
			else
			    count <= count_nx;
		end
	always_comb
	    begin
		    term_count_n = (count == term_val) ? 0 : 1;
		end
endmodule: dw_lp_cntr_updn_df