/*The use of interface/endinterface: Example for ABH protocol

master module  <----------------->    slave module
    [1]interface port            interface port: part of bus
	[2]clk, rstn
	[3] other signal                             not part of bus
*/

/*  Using interface as module port
           [1] interface
           [2] use interface to declare signal for master and slave
           [3] use for top module
*/

/*
    function and task:
	     -   interface can also encapsulate (dong goi) functinality for the communication between modules
			
         -   tasks and function in an interface are referred to as interface method
		 
		 -   The following example adds 2 functions to the simple AHB interface
		      +)  one to generate a parity bit value (tao mot gia tri bit chan le)
			  +)  another function to check that data matches the calculated parity
			       (mot chuc nang khac de kiem tra xem du lieu do co khop voi gia tri chan le duoc tinh toan hay khong
				   kich thuoc data them 1 bit, la bit chan le
*/
interface abh_interface  // list all of signal's bus

     // ~ external signal
    (
	input logic hclk,   
	input logic hresetN
	);                  
	
	// internal signal
	logic [31 : 0] haddr;   // address
	logic [32 : 0] hwdata;  // data sent to slave, with parity bit
	logic [32 : 0] hrdata;  // return data from slave, with parity bit
	logic [2  : 0] hsize;   // transfer size
	logic          hwrite;     // mode read/write
	logic          hready;   // = 1 for transfer finished
	
	
	// function parity generate
	
	function automatic logic parity_gen 
	    (
		logic [31 : 0] data
		);	
	    return (^data);    // calculate parity of data (odd parity)
	endfunction
	
	// function parity check
	
	function automatic logic parity_chk 
	    (
		logic [31 : 0] data,
		logic           parity
		);	
		return (parity === ^data);   // 1 = OK, 0 = parity error;
	endfunction
	                                      
	
	// master module port direction
	modport master_ports
	    (
		input hclk, hresetN,   //from chip level
		input hrdata, hready,   // from ABH slave
		output haddr, hwdata, hsize, hwrite, // signal sent to ABH
		import parity_gen, parity_chk
		);
	
	modport slave_ports
	    (
		input hclk, hresetN,    //from chip level
		input haddr, hwdata, hsize, hwrite,   // from ABH master
		output hrdata, hready,
		import parity_chk
		);
endinterface: abh_interface


/*
MASTER module port list
*/
module master
    (
	// add port's master in abh_interface
	abh_interface.master_ports abh,   // <--------------- interface port with modport
	// add other port 
	
	input logic m_clk,   // master clock
	input logic rstN, 
	input logic  [7 : 0] thing1,   // misc signal; not part bus
	output logic [7 : 0] thing2   // misc signal, not part bus
	);
	/*
	............
	*/
endmodule: master                     

module slave
    (
	abh_interface.slave_ports abh,
	
	// add other port
	input logic    s_clk,
	input logic    rstN,
	input logic [7 : 0] thing2,
	output logic [7 : 0] thing1
	);
	/*
	.............
	*/
endmodule: slave


/*
TOP level netlist module
*/

module chip_top
    logic m_clk;   // master clock
	logic s_clk;   // slave clock
	logic hclk;     // ABH bus clock
	logic hresetN;    // ABH bus reset, active low
	logic chip_rstN;    // reset, active low
	logic [7 : 0] thing1;
	logic [7 : 0] thing2;
	
	// instantiate the interface
	abh_interface abh1
	    (
	    .hclk(hclk),
	    .hresetN(hresetN)
	    );
	
	//instantiate master and connect the interface instance 
	// to the master interface port
	master m_name
	    (
	    .abh(abh1),
	    .rstN(chip_rstN),
	    .m_clk,
	    .thing1,
	    .thing2
	    );
	slave s_name
        (
		.abh(abh1),
		.rstN(chip_rstN),
		.*    // wildcard connecttion shorcut for the other port
        );		
endmodule: chip_top
// page 374

//Import method using a method prototype
// Example: Slave module port direction

modport slave_ports_alt
    (
	output hrdata, hready, // to apb master
	input haddr, hwdata, hsize, hwrite, // from ahb master
	input hclk, hresetN,   // from chip level
	import function logic parity_chk
	    (
		logic [31 : 0] data,
		logic          parity
		)
	);

// calling method defined in an interface
    always_ff @(posedge abh.hclk)
	    abh.hwdata[32] <= ahb.parity_gen(ahb.hwdata[31 : 0]);
		
// For synthesizable RTL interfaces:
// Only use function and void function in interface
// Do not use tasks or always procedure.

/*

Use functions to model functionality inside an interface. Do not use initial 
procedures, always procedures or continuous assignments in synthesizable 
RTL interfaces.
*/