// Code your design here
module count
  #(parameter N = 	4)
  (
    input [N - 1 : 0] data,
	input clk, rst_n,
    output logic [$clog2(N) : 0] cout_o
  );
  
  logic [$clog2(N) : 0] sum [N - 1 : 0];
  logic [$clog2(N) : 0] cout;
  
  always_comb
    begin
      
      sum[0] = data[0];
      for (int i = 1; i < N ; i = i + 1)
        begin
           sum[i] = sum[i - 1] + data[i];
        end
	  cout = sum[N - 1];
    end
  always_ff @(posedge clk or negedge rst_n)
    begin
	  if(~rst_n)
	    cout_o <= 0;
      else
        cout_o <= cout;	  
	end

endmodule: count