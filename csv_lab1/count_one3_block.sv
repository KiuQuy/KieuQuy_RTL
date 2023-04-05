// Code your design

module count
  #(parameter N = 32)
  (
    input [N - 1 : 0] data,
	input clk, rst_n,
    output logic [$clog2(N) : 0] cout_o
  );
  
  logic [$clog2(N) : 0] cout; 
  logic [2 : 0] b4 [7 : 0];
  logic [$clog2(N) : 0] carry [1 : 0];
  always_comb
    begin
	  for(int i = 0; i < 8; i = i + 1)
	    begin
          b4[i] = data[4 * i + 0] + data[4 * i + 1] + data[4 * i + 2] + data[4 * i + 3];
		end
	  
	  carry[0] = b4[0] + b4[1] + b4[2] + b4[3];
	  carry[1] = b4[4] + b4[5] + b4[6] + b4[7];
	  cout = carry[0] + carry[1];
		
	end
  always_ff @(posedge clk or negedge rst_n)
    begin
	  if(~rst_n)
	    cout_o <= 0;
	  else
	    cout_o <= cout;
	    
	end
 
endmodule:count

        
// carry0 = data0 + data1 + data2
// carry1 = data3 + data4 + data5
// carry2 = data6 + data7 + data8