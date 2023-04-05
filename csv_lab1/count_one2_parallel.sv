// Code your design here
module count
#(parameter N = 32)
(
  input  [N - 1 : 0] data,
  output logic [$clog2(N) : 0] cout_o,
  input clk, rst_n
);
  localparam MASK0 = 32'b01010101010101010101010101010101,
             MASK1 = 32'b00110011001100110011001100110011,
             MASK2 = 32'b00001111000011110000111100001111,
             MASK3 = 32'b00000000111111110000000011111111,
             MASK4 = 32'b00000000000000001111111111111111;
           

  logic [N - 1 : 0] sum [4 : 0];
  logic [N - 1 : 0] cout;

  always_comb
    begin
      sum[0]   = (data & MASK0) + ((data   >> 1) & MASK0);
      sum[1]   = (sum[0] & MASK1) + ((sum[0] >> 2) & MASK1);
      sum[2]   = (sum[1] & MASK2) + ((sum[1] >> 4) & MASK2);
      sum[3]   = (sum[2] & MASK3) + ((sum[2] >> 8) & MASK3);
      sum[4]   = (sum[3] & MASK4) + ((sum[3] >> 16) & MASK4);  
      cout = sum[4];
    end

  always_ff @(posedge clk or negedge rst_n)
    begin
	  if(~rst_n)
	    cout_o <= 0;
	  else
	    cout_o <= cout [$clog2(N) : 0];
	end
  
endmodule:count

// MASK(0) = 01010101010101010101
// MASK(1) = 00110011001100110011
// MASK(2) = 1111000011110000111100001111
// MASK(3) = 111111110000000011111111
// MASK(4) = 00000000000000001111111111111111