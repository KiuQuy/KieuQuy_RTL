// Code your testbench here
// or browse Examples
module testbench();
  parameter N = 32;
  logic [N - 1 : 0] data;
  logic [$clog2(N) : 0] cout;
  logic clk;
  logic rst_n;
  
  count #(.N(N)) uut
  (
    .data(data),
    .cout_o(cout),
	.clk(clk),
	.rst_n(rst_n)
  );
  
  initial
    begin
     // $dumpfile("dump.vcd");
    //  $dumpvars;
	
	  clk = 0;
	  rst_n = 1;
	  #3 rst_n = 0;
	  #4 rst_n = 1;
    
      repeat(10)
	  
        begin
		  @(negedge clk)
          data = $random();
          #5;		  
        end
    end
	always #5 clk = ~clk;
	always @(cout)
	    begin
		  $display("time = %t, data in = %b, sum = %d", $realtime(), data, cout);
		end
	
endmodule: testbench