/*
11/05/2023: Sua interface fifo_stalvl.slv: bo input full, bo input empty
            Bo sung them tin hieu enable: enable_write, enable_read.
	
*/
module csv_afifo
    #(
	parameter WIDTH = 32,
	parameter DEPTH = 32
	)
	(
	// write domain clock
	input  i_clk_s,
	input  i_rst_n_s,
	dstm_intf.slv s_dstm,      
	// configure level for fifo
    fifo_stalvl.s_config s_config,
    // read domain clock
	input  i_clk_m,
	input  i_rst_n_m,
	dstm_intf.mst m_dstm,      
	// get status
	fifo_stalvl.mst m_stalvl     
	);
	parameter ASIZE = $clog2(DEPTH);
	logic [ASIZE : 0]     wq2_rptr, wptr;
	logic [ASIZE : 0]     rq2_wptr, rptr;
	logic [ASIZE - 1 : 0]  waddr, raddr;

	/*
	sync_r2w block 
	2 ff synchronizer to synchronize
	read poiter to write clock domain: active theo clock of write domain
	*/

	
	logic [ASIZE : 0] wq1_rptr;
	always_ff @(posedge i_clk_s or negedge i_rst_n_s)
	    begin
		    if(!i_rst_n_s)
			    begin
				    {wq1_rptr, wq2_rptr} <= 0;
				end
			else
			    begin
				    {wq2_rptr, wq1_rptr} <= {wq1_rptr, rptr};		
				end
		end
	/*
	sync_w2r block 
	2 ff synchronizer to synchronize
	write poiter to read poiter domain
	*/

	logic [ASIZE : 0] rq1_wptr;
	always_ff @(posedge i_clk_m or negedge i_rst_n_m)
	    begin
		    if(!i_rst_n_m)
			    begin
				    {rq2_wptr, rq1_wptr} <= 0;
				end
			else 
			    begin
				    {rq2_wptr, rq1_wptr} <= {rq1_wptr, wptr};
				end
		end
		
	//wprt_full block
	
	logic [ASIZE : 0] wbin;
	logic [ASIZE : 0] wgray_next, wbin_next, wgray_next_p1;
	logic             awfull_val, wfull_val;
	always_ff @(posedge i_clk_s or negedge i_rst_n_s)
	    begin
		    if(!i_rst_n_s)
			    begin
				    {wbin,wptr} <= 0;
				end
			else
			    begin
				    {wbin, wptr} <= {wbin_next, wgray_next};
				end
		end
	// Memory write-address pointer (okay to use binary to address memory)
	always_comb
	    begin
		    waddr         = wbin[ASIZE - 1 : 0];
			wbin_next     = wbin + (s_dstm.valid & ~m_stalvl.full);
			wgray_next    =  (wbin_next >> 1 ) ^ wbin_next;
			wgray_next_p1 = ( (wbin_next + s_config.almostfull) >> 1 ) ^ (wbin_next + s_config.almostfull);    // thay doi gia tri almostfull tai day
			wfull_val     = (wgray_next == { ~wq2_rptr[ASIZE : ASIZE - 1], wq2_rptr[ASIZE - 2 : 0]}) ? 1 : 0;
			awfull_val    = (wgray_next_p1 == {~wq2_rptr[ASIZE : ASIZE - 1], wq2_rptr[ASIZE - 2 : 0]}) ? 1 : 0;
		end
	always_ff @(posedge i_clk_s or negedge i_rst_n_s)
	    begin
		    if(!i_rst_n_s)
			    begin
			        m_stalvl.almostfull     <= 0;
				    m_stalvl.full      <= 0;
				end
			else
			    begin
			        m_stalvl.almostfull     <= awfull_val;
				    m_stalvl.full      <= wfull_val;
				end
				
		end
	
	//rprt empty	
	
	logic [ASIZE : 0] rbin;
	logic [ASIZE : 0] rgray_next, rbin_next, rgray_next_m1;
	logic             arempty_val, rempty_val;

    always_ff @(posedge i_clk_m or negedge i_rst_n_m)
	    begin
		    if(!i_rst_n_m)
				{rbin, rptr} <= 0;
			else
			    {rbin, rptr} <= {rbin_next, rgray_next};
		end
	// Memory read-address pointer (okay to use binary to address memory)
	always_comb
	    begin
		    raddr         = rbin[ASIZE - 1 : 0];
			if(m_dstm.ready & ~m_stalvl.empty) rbin_next     = rbin + 1;
            else rbin_next     = rbin;			
			//rbin_next     = rbin + (m_dstm.ready & ~m_stalvl.empty);
			rgray_next    = (rbin_next >> 1) ^ rbin_next;
			rgray_next_m1 = ( (rbin_next + s_config.almostempty ) >> 1 ) ^ (rbin_next + s_config.almostempty);   // thay doi gia tri almostempty tai day
		
		end
	
	// fifo empty when the next rprt == synchronized wprt or on reset;
	always_comb
	    begin 
		    rempty_val   = (rgray_next    == rq2_wptr) ? 1 : 0;
			arempty_val  = (rgray_next_m1 == rq2_wptr) ? 1 : 0;		
		end
	always_ff @(posedge i_clk_m or negedge i_rst_n_m)
	    begin
		    if(!i_rst_n_m)
			    begin
				    m_stalvl.almostempty  <= 0;
					m_stalvl.empty         <= 1;
				end
			else
			    begin
				    m_stalvl.almostempty <= arempty_val;
					m_stalvl.empty       <= rempty_val;
				end
		end
	/*
	fifo memory
	*/
	logic    [WIDTH - 1 : 0] fifo_mem [0: DEPTH - 1];
	
	                // write data
	always_ff @(posedge i_clk_s or negedge i_rst_n_s)
	    begin
		    if(!i_rst_n_s)
			    begin
				end
			else if(s_dstm.valid && !m_stalvl.full)
			    fifo_mem[waddr] <= s_dstm.data;
		end
	                   // read data
	always_comb
	    begin
		    if(m_dstm.ready)
			     m_dstm.data = fifo_mem[raddr];		
		end	
	always_comb
	    begin
            s_dstm.ready         = ~m_stalvl.full;	
			m_dstm.valid         = ~m_stalvl.empty;
			
		end
endmodule: csv_afifo