//       https://www.verilogpro.com/asynchronous-fifo-design/#google_vignette
//       https://github.com/dpretet/async_fifo
//       http://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf

/*
almostfull when fifo level is DEPTH-1
almostempty when fifo level is 1

*/

/*
s_dstm.valid to write if s_dstm.ready==1	
m_dstm.valid is high when fifo level > 1	
m_dstm.ready is to read data from fifo	

s_dstm.ready
m_dstm.valid



*/
interface dstm
    #(
	parameter WIDTH = 8
	)
	();
	logic valid;
	logic [WIDTH - 1 : 0] data;
	logic ready;
	
	modport slv
	    (
		input valid,
		input data,
		output ready
		);
	modport mst
	    (
		input ready,
		output data,
		output valid
		);
endinterface: dstm

interface fifo_stalvl();
    logic full, almostfull; // almostfull = 1 when fifo level  is DEPTH - 1
    logic empty, almostempty;
	
	modport slv
	    (
		input full, almostfull,
		input empty, almostempty
		);
	modport mst
	    (
		output full, almostfull,
		output empty, almostempty
		);
endinterface: fifo_stalvl

module csv_afifo
    #(
	parameter WIDTH = 8,
	parameter DEPTH = 8
	)
	(
	// write domain clock
	input  i_clk_s,
	input  i_rst_n_s,
	dstm.slv s_dstm,      // input_write domain
    fifo_stalvl.mst s_stalvl,
	
    // read domain clock
	input  i_clk_m,
	input  i_rst_n_m,
	dstm.mst m_dstm,      // output read domain
	fifo_stalvl.mst m_stalvl      // status giong nhau o ca read/write domain
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
			wgray_next_p1 = ( (wbin_next + 1) >> 1 ) ^ (wbin_next + 1);    // thay doi gia tri almostfull tai day
			wfull_val     = (wgray_next == { ~wq2_rptr[ASIZE : ASIZE - 1], wq2_rptr[ASIZE - 2 : 0]});
			awfull_val    = (wgray_next_p1 == {~wq2_rptr[ASIZE : ASIZE - 1], wq2_rptr[ASIZE - 2 : 0]});
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
	/*
	
	rprt empty
	
	*/
	
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
			rbin_next     = rbin + (m_dstm.ready & ~m_stalvl.empty);
			rgray_next    = (rbin_next >> 1) ^ rbin_next;
			rgray_next_m1 = ( (rbin_next + 1) >> 1 ) ^ (rbin_next + 1);   // thay doi gia tri almostempty tai day
		end
	
	// fifo empty when the next rprt == synchronized wprt or on reset;
	always_comb
	    begin 
		    rempty_val   = (rgray_next    == rq2_wptr);
			arempty_val  = (rgray_next_m1 == rq2_wptr) ;
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
	                 // status giong nhau o ca read/write domain	
	always_comb
	    begin
		    s_stalvl.full        = m_stalvl.full;
			s_stalvl.almostfull  = m_stalvl.almostfull;
            s_stalvl.empty       = m_stalvl.empty;
            s_stalvl.almostempty = m_stalvl.almostempty;		
            s_dstm.ready         = ~m_stalvl.full;	
			m_dstm.valid         = m_stalvl.almostempty;
			
		end
endmodule: csv_afifo