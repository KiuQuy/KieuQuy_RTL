module dw03_updn_ctr_tb();
    parameter WIDTH = 3;
	// input of dut
	
	logic                  clk;
	logic                  reset;
	logic  [WIDTH - 1 : 0] data;
    logic                  up_dn;
    logic                  load;
    logic                  c_en;

    // output of dut
	logic [WIDTH - 1 : 0]  count;
	logic                  tercnt;
    // instantiate uut
	dw03_updn_ctr
	#(
	.WIDTH(WIDTH)
	) uut
	(
	.clk(clk),
	.reset(reset),
	.data(data),
	.up_dn(up_dn),
	.load(load),
	.c_en(c_en),
	.count(count),
	.tercnt(tercnt)	
	);
	initial
	    begin
		    clk = 0;
			// functional operation 1
			
			reset = 1;
			load  = 1;
			c_en  = 0;
			up_dn = 1;
			#3  reset = 0;
			#4  reset = 1;
			    load  = 0;
			    data  = 0;
			#20 load  = 1;
			#10 c_en  = 1;
			
			#100
			// functional operation 2
			reset = 1;
			load  = 1;
			c_en  = 1;
			up_dn = 1;
			data  = 1;
			#20  up_dn = 0;
		end
	always #5 clk = ~clk;
	
endmodule: dw03_updn_ctr_tb