module crc_bit_sequence_tb;

    logic clk, rst_n;
	logic [7 : 0] data_in;
	logic         valid;
    logic [5 : 0] crc_out;
	
	// instantiate design
	crc_bit_sequence uut
	(
	.clk(clk),
	.rst_n(rst_n),
	.data_in(data_in),
	.valid(valid),
	.crc_out(crc_out)
	);
	
	initial
	    begin
		    clk = 0;
			rst_n = 1;
			#3 rst_n = 0;
			#4 rst_n  = 1;
			repeat(20)
			    begin
				    @(negedge clk);
					    data_in = $random();
						valid   = $random();
				end
		end
	always #5 clk = ~clk;
endmodule: crc_bit_sequence_tb