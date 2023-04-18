module csv_sfifo_tb();
    parameter WIDTH  = 9;
	parameter DEPTH  = 8;
	logic i_clk;
	logic i_rst_n;
	// instantiate the interface
	dstm #(.WIDTH_IF(WIDTH)) s_dstm(), m_dstm();
	fifo_stalvl s_fifo(), m_fifo();
	//virtual dstm.slv Sdstm;
	//virtual dstm.mst Mdstm;
	//virtual fifo_stalvl Mstalvl;
	// instantiate csv_sfifo and 
	//connect the interface instance
	// to the csv_sfifo
    csv_sfifo 
    #(
	//.WIDTH(WIDTH),
	.WIDTH(8),
	.DEPTH(DEPTH)
    ) fifo_inst
    (
	.i_clk(i_clk),
	.i_rst_n(i_rst_n),
	.m_dstm(m_dstm),
	.s_dstm(s_dstm),
	.m_stalvl(m_fifo)
    );	
	
	//generate signal
	initial
	    begin
		    i_clk = 0;
			#3 i_rst_n = 1;
			#2 i_rst_n = 0;
			#4 i_rst_n = 1;
			
			
			
			// Write to full
			repeat(10)
			    begin
				    @(negedge i_clk);
                        s_dstm.data = $random();	
						s_dstm.valid = 1;
						m_dstm.ready = 0;

					
				end
			// Read to empty
			repeat(10)
			    begin
				    @(negedge i_clk);
					    m_dstm.ready = 1;
						s_dstm.valid = 0;
				end
			// write 
			repeat(5)
			    begin
				    @(negedge i_clk);
                        s_dstm.data = $random();	
						s_dstm.valid = 1;
						m_dstm.ready = 0;
				end
			// read and write simultaneously
            repeat(20)
                begin
				    @(negedge i_clk)
					    s_dstm.data = $random();
						s_dstm.valid = 1;
						m_dstm.ready = 1;
						
				end
				
		end
	always #5 i_clk = ~i_clk;
	
endmodule: csv_sfifo_tb