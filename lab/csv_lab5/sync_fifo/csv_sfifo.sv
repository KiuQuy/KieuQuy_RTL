/*
Sync fifo
use DSTM interface: Digilent Synchronous Parallel Interface
*/


/*
almostfull when fifo level is DEPTH-1
almostempty when fifo level is 1

*/

/*
s_dstm.valid to write if s_dstm.ready==1	
m_dstm.valid is high when fifo level > 1	
m_dstm.ready is to read data from fifo	
*/
interface dstm
    #(
	parameter WIDTH_IF = 16
	)
    ();
    logic valid;
	logic [WIDTH_IF - 1 : 0] data;
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
		output valid,
		output data
		);
endinterface: dstm


interface fifo_stalvl();
    logic full, almostfull;   //almostempty when fifo level is DEPTH-1
	logic empty, almostempty; //almostempty when fifo level is 1
	
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

module csv_sfifo
    #(
	parameter WIDTH = 8,
	parameter DEPTH = 8
	)
	(
	input i_clk,
	input i_rst_n,
	dstm.slv s_dstm,    	
	dstm.mst m_dstm,   
    fifo_stalvl.mst m_stalvl   
	);
	localparam AW = $clog2(DEPTH);
	//read signal ~ for master interface
	//logic [AW : 0]     r_prt;  // du 1 slot
	//logic [AW - 1 : 0] r_adr;
	logic              r_en;	
	// write signal ~ for slave interface
	logic [AW : 0]     w_prt;
	logic [AW - 1 : 0] w_adr;
	logic              w_en;
	// memory to save data
	logic [WIDTH - 1 : 0] fifo_mem [0 : DEPTH - 1];
	//control read
	always_comb
	    begin
		    m_dstm.valid = (w_prt > 1) ? 1 : 0; 
			// spec require m_dstm.valid is high when fifo level > 1	
			r_en = (~m_stalvl.empty) & m_dstm.ready;
		    //r_adr = r_prt[AW - 1 : 0];
			m_stalvl.empty = (w_prt == 0) ? 1 : 0;
			//m_stalvl.almostempty = (w_prt - r_prt) <= 1;	
			m_stalvl.almostempty = (w_prt == 1) ?  1 : 0;
		end
	/*always_ff @(posedge i_clk or negedge i_rst_n)
	    begin
		    if(!i_rst_n)
			    r_prt <= 0;
			else
			    begin
				    if(r_en & (~w_en))
					    r_prt <= r_prt + 1;
					else if(r_en & w_en)
					    r_prt <= r_prt;
				end
		end
	*/
	//control write
	always_comb
	    begin
		    w_adr = w_prt[AW - 1 : 0];
			m_stalvl.full = (w_prt == DEPTH) ? 1 : 0;
			w_en = ~m_stalvl.full & s_dstm.valid;
			//m_stalvl.almostfull = (w_prt - r_prt == DEPTH - 1) >= DEPTH - 1 ;
			m_stalvl.almostfull = (w_prt == DEPTH - 1) ? 1 : 0;
			s_dstm.ready = ~m_stalvl.full;
		end
	always_ff @(posedge i_clk or negedge i_rst_n)
	    begin
		    if(!i_rst_n)
			    w_prt <= 0;
			else
			    begin
				    if(w_en & (!r_en))
					    w_prt <= w_prt + 1;
					else if (w_en & r_en)
					    w_prt <= w_prt;
					else if((!w_en) & r_en)
					    w_prt <= (w_prt == 0) ? 0 : (w_prt - 1);
					
				end
		end
	always_ff @(posedge i_clk or negedge i_rst_n)
	    begin
		    if(~i_rst_n) 
			    begin
				    for(int i = 0; i < DEPTH; i++)
					    begin
						    fifo_mem[i] <= 0;
						end
                end				
			else
		        begin
					if(w_en & (!r_en))    //       write
					    begin
						    fifo_mem[w_adr] <= s_dstm.data;
						end
					if(r_en)   // 
			  		    begin				
				    		m_dstm.data <= fifo_mem[0];  // read
				    		for(int i = 0; i < DEPTH; i++) 
					    		begin
						  		    if (i <= w_adr - 1)
							    		fifo_mem[i] <= fifo_mem[i + 1];   // for pull
									else if (w_en)
			  				            fifo_mem[w_adr - 1] <= s_dstm.data;   // no pull in here
							
								end 
						end
				end
		end
	
endmodule: csv_sfifo

