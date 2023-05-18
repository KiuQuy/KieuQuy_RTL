module apb_fifo_tb;
    // declare signal to connect to design module
	logic clk3, rst_n3;  // // domain 3: between IP1 and IP2
	
	apb_intf  apb_slave1();  // apb_slave in IP1
	apb_intf  apb_slave2();  // apb_slave in IP2
	
	// instantiate design module
	apb_fifo apb_fifo_uut
	(
	.clk3(clk3),
	.rst_n3(rst_n3),
	.apb_intf_slv1(apb_slave1),
	.apb_intf_slv2(apb_slave2)
	);
	
	// clock in doamin 3
	initial 
	    begin
		    clk3 = 0;
			#50 rst_n3 = 1;
			#40 rst_n3 = 0;
			#70 rst_n3 = 1;
		end
	always #20 clk3 = ~ clk3;
	
	
	initial
	    begin
		    // clk + reset in IP1 + IP2
		    apb_slave1.pclk = 0;
			apb_slave2.pclk = 0;
			
			#50 apb_slave1.preset_n = 1;
			    apb_slave2.preset_n = 1;
			
			#30 apb_slave1.preset_n = 0;
			    apb_slave2.preset_n = 0;
			
			#30 apb_slave1.preset_n = 1;
			    apb_slave2.preset_n = 1;
			
			#200
			// IP1 write
			repeat(40)
			    begin
				    @(negedge apb_slave1.pclk);
					
				    apb_slave1.paddr       = 32'h08; // access to ACTIVE register to write data into asyn fifo
					apb_slave1.pwrite      = 1;
					apb_slave1.psel        = 1;
					apb_slave1.pwdata      = $random();
					apb_slave1.penable     = 0;
					apb_slave1.pstrb       = 4'hF;
					@(negedge apb_slave1.pclk);			
					apb_slave1.penable     = 1;
				end
			// IP2 read
			repeat(20)
			    begin
				    @(negedge apb_slave2.pclk);
					apb_slave2.paddr       = 32'h08; // ACCESS to ACTIVE register in Register Block to read data from async fifo rx2
					apb_slave2.pwrite      = 0;
					apb_slave2.psel        = 1;
					apb_slave2.penable     = 0;
					@(negedge apb_slave2.pclk);
					apb_slave2.penable     = 1;
					
				end
		end
	always #15 apb_slave1.pclk = ~ apb_slave1.pclk;
	always #25 apb_slave2.pclk = ~ apb_slave2.pclk;
	
	
endmodule