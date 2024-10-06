
module test_crc_2bit;
	logic                clk;
	logic                rst;   // Async active-low reset
	logic                init;  // Sync  active-high reset
	logic                en;    // active-high enable, data input bis are valid
	logic        [1 : 0] din;
	logic        [7 : 0] crc;
    
	// instantiate crc_2bit
	crc_2bit dut
	(
	.clk(clk),
	.rst(rst),
	.init(init),
	.en(en),
	.din(din),
	.crc(crc)
	);
	
	initial
	    begin
		    clk = 0;
			rst = 1;
			init = 0;
			#3 rst = 0;
			#4 rst = 1;
			repeat(20)
			    begin
				    @(negedge clk) 
					en = 1;
					din = $random();
				end
		end
	always #5 clk = ~clk;
endmodule: test_crc_2bit