
// Code your design here
module gray_counter
    #(parameter N = 4)
    (
    input clk,
    input rstn,
    output logic [N - 1 : 0] gray
    );
    logic [N - 1 : 0] bin;
    always_ff @ (posedge clk, negedge rstn)
    begin
        if(~rstn) bin <= 0;
        else
            begin
                bin <= bin + 1;
            end
    end
  
    always_comb
        begin
	        gray[N - 1] = bin[N - 1];
        
 	        gray = bin ^ {0, bin[N - 1 : 1]};
        end
endmodule: gray_counter