module crc_1bit
    (
	input                clk, 
	input                rst,   // Async active-low reset
	input                init,  // Sync  active-high reset
	input                en,    // active-high enable, data input bis are valid
	input                din,
	input  logic [7 : 0] in_crc_reg,
	output logic [7 : 0] out_crc_reg,
	output logic [7 : 0] out_crc_next
	);
	logic feedback;
	always_comb
	    begin
		    feedback              =    in_crc_reg[7] ^ din;
			out_crc_next[0]       =    feedback;
			out_crc_next[1]       =    in_crc_reg[0] ^ feedback;  
			out_crc_next[2]       =    in_crc_reg[1] ^ feedback;
			out_crc_next[3]       =    in_crc_reg[2] ^ feedback;
			out_crc_next[4]       =    in_crc_reg[3];
			out_crc_next[5]       =    in_crc_reg[4] ^ feedback;
			out_crc_next[6]       =    in_crc_reg[5];
			out_crc_next[7]       =    in_crc_reg[6];
		end
	
	always_ff @(posedge clk or negedge rst)
	    begin
		    if(!rst)   // async + active low
			    out_crc_reg <= 8'hFF;
			else if(init)  // Sync + active high
			    out_crc_reg <= 8'hFF;
			else
			    out_crc_reg <= out_crc_next;
		end
	/*
	always_ff @(posedge clk or negedge rst)
	    begin
		    if(!rst)   // async + active low
			    crc     <= 8'hFF;
			else if(init)  // Sync + active high
			    crc     <= 8'hFF;
			else
			    crc     <= crc_reg;
		end	
	*/
endmodule: crc_1bit