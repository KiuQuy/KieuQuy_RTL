/*
Select is an onehot encoded number
*/

//interface mux_one_hot
module mux_one_hot
    #(
	parameter int unsigned IN_NUM = 4,
	parameter int unsigned BW     = 4
	)
	(
	input clk, rst_n,
	input logic  [IN_NUM - 1 : 0]       s,
	input logic  [BW - 1 : 0] i [IN_NUM - 1 : 0] ,
	output logic [BW - 1 : 0]       o_out
	);
	logic [BW - 1 : 0]       o;	
	always_comb
	    begin
		    o = '0;
			for (int unsigned k = 0; k < IN_NUM; k++)
			    begin
			        o |= (i[k] & {BW{s[k]}});
				end			
		end
	always_ff @(posedge clk or negedge rst_n)
	    begin
		    if(~rst_n)
			    o_out <= 0;
			else
			    o_out <= o;		    
		end
endmodule: mux_one_hot

//endinterface: mux_one_hot