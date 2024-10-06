interface dstm_intf
    #(
	parameter DATA = 32
	)
	();
	logic valid;
	logic [DATA - 1 : 0] data;
	logic ready;
	modport slv  // write
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
	
endinterface: dstm_intf