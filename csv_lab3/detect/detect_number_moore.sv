module detect_number // mearly output
	(
	input clk, rst_n,
	input valid, data_in,
	output logic found
	);
    logic [2 : 0] cnt, cnt_nx;
	logic [4 : 0] temp_data;
    always_ff @ (posedge clk or negedge rst_n)
        begin
		    if(~rst_n)
			    cnt <= 0;
			else
			    cnt <= cnt_nx;
        end
    always_comb
        begin
		    if(valid)
		        cnt_nx = (cnt == 5) ? 5 : (cnt + 1);
        end	
    always_ff @(posedge clk or negedge rst_n)
        begin
		    if(!rst_n)
			    temp_data <= 0;
			else
			    if(valid)
				    begin
			            temp_data <= {data_in, temp_data[4 : 1]};
					end
                else 
                    temp_data <= temp_data;				
        end	
    always_comb
	    if(valid)
            found = (cnt == 5 & ( temp_data == 5'b11011)) ? 1 : 0;	
endmodule: detect_number
/*
input               set_detect_number
input logic [4 : 0] detect_number
*/