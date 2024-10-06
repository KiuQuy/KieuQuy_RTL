module crc_2bit
    (
	input                clk, 
	input                rst,   // Async active-low reset
	input                init,  // Sync  active-high reset
	input                en,    // active-high enable, data input bis are valid
	input        [1 : 0] din,
	output logic [7 : 0] crc
	);
	
	logic [7 : 0] crc_reg_s0, crc_next_s0;
	logic [7 : 0] crc_reg_s1, crc_next_s1;
	always_ff @(posedge clk or negedge rst)
	    begin
		    if(!rst)   // async + active low
			    crc <= 8'hFF;
			else if(init)  // Sync + active high
			    crc <= 8'hFF;
			else
			    crc <= crc_reg_s1;
		end
	crc_stage0 stage0
	(
	.clk(clk),
	.rst(rst),
	.init(init),
	.en(en),
	.din(din[0]),
	.in_crc_reg(crc_reg_s1),
	.out_crc_next(crc_next_s0)
	);
    
    crc_stage1 stage1
	(
	.clk(clk),
	.rst(rst),
	.init(init),
	.en(en),
	.din(din[1]),
	.in_crc_reg(crc_next_s0),
	.out_crc_reg(crc_reg_s1),
	.out_crc_next(crc_next_s1)
	);
endmodule: crc_2bit

