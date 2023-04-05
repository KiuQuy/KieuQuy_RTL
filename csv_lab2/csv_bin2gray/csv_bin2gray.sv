// Code your design here
/*
Convert binary code to Gray code,
input and output width are parameterized
*/
module csv_bin2gray
    #(parameter N = 4)
    (
    input clk, rst_n,
    input logic  [N - 1 : 0] bin,
    output logic [N - 1 : 0] gray_o
    );
	logic [N - 1 : 0] gray;
    always_comb
        begin
            gray[N - 1] = bin[N - 1];
                for(int i = 0; i < N - 1; i = i + 1)
                    begin
                        gray[i] = bin[i] ^ bin[i + 1];
                    end
        end
	always_ff @(posedge clk or negedge rst_n)
	    begin
		    if(!rst_n)
			    gray_o <= 0;
			else
			    gray_o <= gray;
		end
endmodule: csv_bin2gray