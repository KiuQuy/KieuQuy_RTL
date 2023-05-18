interface apb_intf
    #(
	parameter SEL   = 1,
	parameter STRB  = 4,
	parameter DATA  = 32,
	parameter ADDR  = 32
	)
	();
	logic                pclk;
	logic                preset_n;
	logic [ADDR - 1 : 0] paddr;
	logic [SEL  - 1 : 0] psel;
	logic                penable;
	logic                pwrite;
	logic [DATA - 1 : 0] pwdata;
	logic [STRB - 1 : 0] pstrb;
	
	logic                pready;
	logic [DATA - 1 : 0] prdata;
	logic                pslverr;

	modport slv
        (	
      		
		input    pclk,
		input    preset_n,
		
		input    paddr,  
		input    psel,
		input    penable,
		input    pwrite,
		input    pwdata,
		input    pstrb,
		
		output   pready,
		output   prdata,
		output   pslverr
		);
endinterface: apb_intf