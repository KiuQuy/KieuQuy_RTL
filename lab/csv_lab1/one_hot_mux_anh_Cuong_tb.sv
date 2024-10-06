module mux_one_hot_tb();
    parameter int unsigned IN_NUM = 4;
	parameter int unsigned BW     = 4;
	
	logic [IN_NUM - 1 : 0] s;
	logic [BW - 1 : 0] i [IN_NUM - 1 : 0];
	logic [BW - 1 : 0] o;
	logic clk, rst_n;
	
	mux_one_hot 
	#(
	.IN_NUM(IN_NUM), 
	.BW(BW)
	) uut
	(
	.s(s),
	.i(i),
	.o_out(o),
	.clk(clk),
	.rst_n(rst_n)
	);
	
	initial 
	    begin
		  //  $monitor("i1 = %d, i2 = %d, i3 = %d, i4 = %d, sel = %b, o = %d", i[0], i[1], i[2], i[3], s, o);
		    clk = 0;
			s = 1;
			rst_n = 1;
			#5 rst_n = 0;
			#4 rst_n = 1;
			repeat(30)
			    @(negedge clk)
			    begin
				    i[0] = $random();
				    i[1] = $random();
					i[2] = $random();
					i[3] = $random();
					#5;
					
				end	
		end
	always @(negedge clk)  s = s + 1;
	always #5 clk = ~clk;
	always @(o)
	    begin
		    $display("i1 = %d, i2 = %d, i3 = %d, i4 = %d, sel = %b, o = %d", i[0], i[1], i[2], i[3], s, o);
		end
    
endmodule: mux_one_hot_tb