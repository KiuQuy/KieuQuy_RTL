// Code your design here
 /*
Convert gray to bin
input and output width are parameterized
*/
module csv_gray2bin
    #(parameter N = 4)
    (
    input  logic  [N - 1 : 0] gray,
	input clk, rst_n,
    output logic  [N - 1 : 0] bin_o
    );
	logic [N - 1 : 0] bin;
    always_comb
        begin
            bin[N - 1] = gray[N - 1];
            for(int i = N - 2; i >=  0; i = i - 1)
	        begin
                bin[i] =  bin[i + 1] ^ gray[i];
	        end
        end
	always_ff @(posedge clk or negedge rst_n)
	    begin
		    if(!rst_n)
			    bin_o <= 0;
			else
		        bin_o <= bin;
		end
endmodule: csv_gray2bin