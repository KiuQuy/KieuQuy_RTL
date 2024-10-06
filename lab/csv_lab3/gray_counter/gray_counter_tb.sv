module gray_counter_tb;
    parameter N = 4;
    logic clk;
	logic rstn;
	logic [N - 1 : 0] gray;
	
	// connect to uut
	gray_counter #(.N(N)) uut
	(
	.clk(clk),
	.rstn(rstn),
	.gray(gray)
	);
	
	initial 
	    begin
		    $monitor("time = %t, gray = %b", $realtime(), gray);
		    clk = 0;
			rstn = 0;
			#3 rstn= 1;
		end
	always #5 clk = ~ clk;

endmodule: gray_counter_tb