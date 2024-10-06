module async_fifo_tb();
    parameter WIDTH = 8;
	parameter DEPTH = 8;
	
	logic i_clk_s;
	logic i_rst_n_s;
	dstm #(.WIDTH(WIDTH)) s_dstm(), m_dstm();
	fifo_stalvl s_stalvl(), m_stalvl();
	logic i_clk_m;
	logic i_rst_n_m;
	
	// instantiate design module
	csv_afifo 
	#(
	.WIDTH(WIDTH),
	.DEPTH(DEPTH)
	)
	 csv_afifo_uut
	(
	.i_clk_s(i_clk_s),
	.i_rst_n_s(i_rst_n_s),
	.s_dstm(s_dstm),
	.s_stalvl(s_stalvl),
	
	.i_clk_m(i_clk_m),
	.i_rst_n_m(i_rst_n_m),
	.m_dstm(m_dstm),
	.m_stalvl(m_stalvl)
	);
	// stimulus signal
	initial
	    begin
		    i_clk_m = 0;
			i_clk_s = 0;
            m_dstm.ready  = 0;
			s_dstm.valid  = 0;
			#3 i_rst_n_m = 1;
			#2 i_rst_n_s = 1;
			#7 i_rst_n_m = 0;
			#2 i_rst_n_s = 0;
			#7 i_rst_n_m = 1;
			#2 i_rst_n_s = 1;			
			// write to full: write domain
			repeat(10)
			    begin
				    @(negedge i_clk_s);
					    s_dstm.data   = $random();
                        s_dstm.valid  = 1;
                        m_dstm.ready  = 0;						
				end
			// read to empty
			repeat(10)
			    begin
				    @(negedge i_clk_m)
					    m_dstm.ready  = 1;
						s_dstm.valid  = 0;
				end
			// write to almostfull
			repeat(5)
			    begin
				    @(negedge i_clk_s)
					    s_dstm.data  = $random();
						s_dstm.valid = 1;
						m_dstm.ready = 0;
				end
			// read and write stimultaneously
			repeat(10)
			    begin
				    @(negedge i_clk_s)
					    s_dstm.data   = $random();
						s_dstm.valid  = 1;
					@(negedge i_clk_m)
					    m_dstm.ready  = 1;
				end
		end
	always #20 i_clk_m = ~i_clk_m;
	always #5 i_clk_s = ~i_clk_s;
endmodule: async_fifo_tb