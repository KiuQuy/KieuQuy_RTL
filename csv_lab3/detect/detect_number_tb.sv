module detect_number_tb();
    logic clk, rst_n;
	logic valid, data_in;
	logic found;
	
	// instantiate module
	detect_number 
	//detect_number_fsm
	uut
	(
	.clk(clk),
	.rst_n(rst_n),
	.valid(valid),
	.data_in(data_in),
	.found(found)
	);
	initial
	    begin
		    clk = 0;
			rst_n = 1;
			#2 rst_n = 0;
			#7 rst_n = 1;	
			repeat(10)
			    begin
				    @(negedge clk)
					    data_in = 1;
						valid   = 1;
				    @(negedge clk)
					    data_in = 1; 
						valid   = 1;
				    @(negedge clk)
					    data_in = 0;
						valid   = 1;
				    @(negedge clk)
					    data_in = 1;
						valid   = 1;
				    @(negedge clk)
					    data_in = $random();
						valid   = $random();
				    @(negedge clk)
					    data_in = $random();
                        valid   = $random();						
				end
		end
	always #5 clk = ~clk;
endmodule: detect_number_tb