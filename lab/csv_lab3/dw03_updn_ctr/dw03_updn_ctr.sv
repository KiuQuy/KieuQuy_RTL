module dw03_updn_ctr
    #(
	parameter WIDTH = 3
	)
	(
	// input of design
	input                  clk, 
	input                  reset, // async counter reset, active low
	input  [WIDTH - 1 : 0] data,  // input data bus
	input                  up_dn,  // up_dn = 1 => count up, up_dn = 0 => count down
	input                  load,  // counter load enable active low
	input                  c_en,  // counter enable, active high
	
	// output of design
	output logic [WIDTH - 1 : 0] count, // output count bus
	output logic                tercnt // terminal count flag
	);
	
	logic [WIDTH - 1 : 0]  count_nx;
	
	always_ff @(posedge clk or negedge reset)
	    begin
		    if(!reset)
			    count <= 0;
			else
			    count <= count_nx;
		end
	always_comb
	    begin
		    if(!load)
			    begin
				end
			else if (!c_en)  //c_en = 0; counter is disable
			    count_nx = count;
			else  //c_en = 1 => counter is active
				begin
			        if (!up_dn)   // count down
			            count_nx = count - 1;
                    else  		       // count up
                        count_nx = count + 1;
                end											
		end
	always_comb // for tercnt
                // When counting up, tercnt is high at count = “111....111”. When counting 
                // down, tercnt is high at count = “000....000”.
        begin
		    if(up_dn & (&count) )  //&: single bit; &&: all			
			    tercnt = 1;
			else if (!up_dn & (count == 0) )  //  or: ~| count && !up_dn
			    tercnt = 1;
			else
			    tercnt = 0;
		end
endmodule: dw03_updn_ctr