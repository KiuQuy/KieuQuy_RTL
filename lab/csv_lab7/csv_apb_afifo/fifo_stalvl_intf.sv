interface fifo_stalvl
    #(
	parameter WIDTH = 8  // use for fifo level
	)
	();
    logic full;
	logic [WIDTH - 1 : 0] almostfull; // almostfull = 1 when fifo level  is DEPTH - 1
    logic empty;
	logic [WIDTH - 1 : 0] almostempty;
	
	modport slv  // input of register block 
	    (
		input almostfull, full,
		input almostempty, empty
		);
	modport mst  // output of fifo ->  register block
	    (
		output full, almostfull,
		output empty, almostempty
		);
	modport s_config   // input of fifo 
	    (
		input almostempty,
		input almostfull
		);
	modport m_config   // output of regblock
        (
		output almostempty,
		output almostfull
        );		
endinterface: fifo_stalvl

