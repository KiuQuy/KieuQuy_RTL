/*
   thieu interrupt, 
   pslverr
*/


/*
[1] can them tin hieu enable cho FIFO, trong bai nay khong su dung
[2]: Khi nao ghi vao fifo: khi co tin hieu apb_write + fifo khong full
[3]: Khi nao read tu fifo: kho co tin hieu apb_read + fifo khong empty
*/
module register_block
    #(
	parameter WIDTH_FIFO = 32,  // FIFO + APB 
	parameter DEPTH_FIFO = 32,  // FIFO
	parameter ADDR       = 32, // APB
	parameter DATA       = 32, // APB
	parameter SEL        = 1,  // APB
	parameter STRB       = 4   // APB
	)
	(
	// interface of apb slave  
    apb_intf.slv   apb_slave,	
	// fifo tx
	dstm_intf.mst               write_tx,  // output of regblock (master): write to fifo tx
	fifo_stalvl.m_config   config_tx, // output of regblock => config level for FIFO tx
	fifo_stalvl.slv        status_tx, // get status from fifo tx	
	
	// fifo rx
	dstm_intf.slv               read_rx,  // data is sent to reg block
	fifo_stalvl.m_config   config_rx,  // output of regblock => config level for FIFO rx
	fifo_stalvl.slv        status_rx  // get status from fifo rx
	);
	
	
	// ADDRESS
	// STATUS: RO
	typedef enum logic [31 : 0]
	{
	STATUS      = 32'h00,
	CONFIG      = 32'h04,
	ACTIVE      = 32'h08,
	INTR        = 32'h0c
	} address_t;
	 address_t address;

    logic [31 : 0] r_status, r_config, r_active, r_intr;
	
	// APB => FIFO TX
	logic apb_write, apb_read;
		// PSTRB
	logic [31 : 0] mask; // use for strb
	logic [31 : 0] pwdata;  // masked
	always_comb
	    begin
		    mask[31 : 0] =  { {8{apb_slave.pstrb[3]}}, {8{apb_slave.pstrb[2]}}, {8{apb_slave.pstrb[1]}}, {8{apb_slave.pstrb[0]}} };
			pwdata = apb_slave.pwdata & mask;
		end
	// Pready
	always_comb
	    begin
		    apb_write = apb_slave.psel & apb_slave.penable & apb_slave.pwrite;
	        apb_read  = apb_slave.psel & apb_slave.penable & (!apb_slave.pwrite);
		end
    // register	:  chia nho ra
    always_comb
	    begin
		    r_status    =   { 8'b0
			                , 4'b0
			                , status_tx.almostfull
							, status_tx.almostempty
							, status_tx.full
							, status_tx.empty
							, 8'b0
							, 4'b0
							, status_rx.almostfull
							, status_rx.almostempty
					        , status_rx.full
							, status_rx.empty
							};
		end	 
    always_comb
        begin	
			r_config    =   { config_rx.almostempty
							, config_rx.almostfull
							, config_tx.almostempty
							, config_tx.almostfull
			                };
		end	
    always_comb
        begin	
    		r_active    =   { 30'b0
			                , write_tx.ready
							, read_rx.valid
			                };
		end
	always_comb
	    begin    
			r_intr      =   {0
			                 
                            };					
		end	
	//  READ 
	logic [31 : 0] prdata;
	always_comb
	    begin
			read_rx.ready    = 0;
			prdata           = 0;
            if(apb_read)
            begin			
		        case(apb_slave.paddr)
				    STATUS:   
                        begin 
				            prdata = r_status;   // read					
                        end	
			    	CONFIG:  
					    begin
						    prdata = r_config;  // read
					    end
					
				    ACTIVE:  // READ FROM ASYNC FIFO RX
    					begin
						    if(read_rx.valid) prdata = read_rx.data;
                            else prdata = 0;
							
                            read_rx.ready    = 	apb_read;						
					    end
                    
				    INTR:  
				    	begin
						    prdata = r_intr; 
				    	end
				endcase    
			end
		end	
	always_ff @(posedge apb_slave.pclk or negedge apb_slave.preset_n)
        begin
		    if(!apb_slave.preset_n)
			    apb_slave.prdata <= 0;
            else
			    apb_slave.prdata <= prdata;
			
        end	
    	
	// WRITE: config level	
	always_comb   
	    begin
		    //apb_slave.prdata = 0;
			config_rx.almostempty  = 4;
			config_rx.almostfull   = 5;
			config_tx.almostempty  = 3;
			config_tx.almostfull   = 6;
            if(apb_write)
            begin			
		        case(apb_slave.paddr)
			    	STATUS:   // RO
					    begin
						end
				    CONFIG:  // RW	
				    	begin   
						    config_rx.almostempty  = pwdata[31 : 24];  // write
							config_rx.almostfull   = pwdata[23 : 16];
					    	config_tx.almostempty  = pwdata[15 : 8];
					    	config_tx.almostfull   = pwdata[7  : 0];
					    end
				    ACTIVE:  // RW
				    	begin
						          						
					    end
					INTR:
					    begin
						end
				endcase 
            end				
		end
	// WRITE: dstm_AsynFIFO_TX
	always_comb
	    begin
		    //apb_slave.prdata = 0;
			
			    if(apb_write)
				begin
				    case(apb_slave.paddr)
						ACTIVE:
						    begin
							    write_tx.valid = apb_write;   // = 1
                                write_tx.data  = pwdata;
								
							end
					endcase
				end
				else 
				    write_tx.valid = 0;
		end

	// pslverr
	
	logic pslverr_temp;
    always_comb
        begin
		    if(apb_write)
			    begin
                    if(status_tx.full & apb_slave.paddr == ACTIVE)
					    pslverr_temp = 1;
                    else
                        pslverr_temp = 0;					
                end	
            else if(apb_read)
                begin
                    if(status_rx.empty & apb_slave.paddr == ACTIVE)
					    pslverr_temp = 1;
					else
					    pslverr_temp = 0;
				end
             //......................
			else 
			    pslverr_temp = 0;
        end	
    always_ff @ (posedge apb_slave.pclk or negedge apb_slave.preset_n)
        begin
		    if(!apb_slave.preset_n)
			    apb_slave.pslverr <= 0;
			else
			    apb_slave.pslverr <= pslverr_temp;
        end
    // pready
    always_comb
        begin
		    if(apb_slave.pwrite & status_tx.full)         // write
			    apb_slave.pready = 0;
			else if(!apb_slave.pwrite & status_rx.empty)  // read
			    apb_slave.pready = 0;
			else
			    apb_slave.pready = 1;
        end		
endmodule: register_block

/*
khi full, write tx (full)  =>
full => ready = 0
*/








