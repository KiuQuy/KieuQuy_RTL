module simple_spi_tb();
    logic serial_in, clk, rstN;
	logic data_rdy;
	logic [7 : 0] data;
	// instance module
	
	//simple_spi uut1
	simple_spi_reverse_encode uut2
	(
	.clk(clk),
	.rstN(rstN),
	.serial_in(serial_in),
	.data_rdy(data_rdy),
	.data(data)
	);
	
	// stimulate signal
	initial
	    begin
		    clk = 0;
			rstN = 1;
			#5 rstN = 0;
			#5 rstN = 1;
			repeat (20)
			    begin
				    @(negedge clk) serial_in = $random();
				end
		end
	always #5 clk = ~clk;
	
	

endmodule: simple_spi_tb