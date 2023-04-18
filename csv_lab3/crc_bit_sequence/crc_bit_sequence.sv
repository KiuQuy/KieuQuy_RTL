//Cyclic Redundancy Check
// https://stackoverflow.com/questions/25415724/understanding-two-different-ways-of-implementing-crc-generation-with-lfsr
// tool online : http://outputlogic.com/?page_id=321
//  https://bues.ch/cms/hacking/crcgen
/*
co-efficients of generator polynomial: 
       x^5 + x^2 + x^1 + x^0 = 100111
size: 6 bit
size data input: 8
size data output crc : 5 (= 6 - 1)
*/
module crc_bit_sequence
    (
	input                      clk, rst_n,
	input         [7 : 0]      data_in,
	input                      valid,
	output logic  [5 : 0]      crc_out
	);
	logic [5 : 0] lfsr_q, lfsr_c;
	
	assign crc_out = lfsr_q;
	always_comb
	    begin
		    lfsr_c[0] = lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[4] ^ data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[6];
            lfsr_c[1] = lfsr_q[2] ^ lfsr_q[4] ^ lfsr_q[5] ^ data_in[0] ^ data_in[4] ^ data_in[6] ^ data_in[7];
            lfsr_c[2] = lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[5] ^ data_in[0] ^ data_in[2] ^ data_in[3] ^ data_in[5] ^ data_in[6] ^ data_in[7];
            lfsr_c[3] = lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[4] ^ lfsr_q[5] ^ data_in[1] ^ data_in[3] ^ data_in[4] ^ data_in[6] ^ data_in[7];
            lfsr_c[4] = lfsr_q[0] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[5] ^ data_in[2] ^ data_in[4] ^ data_in[5] ^ data_in[7];
            lfsr_c[5] = lfsr_q[0] ^ lfsr_q[3] ^ data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[5];
		end
	always_ff @(posedge clk or negedge rst_n)
	    begin
		    if(!rst_n)
			    lfsr_q <= {6{1'b0}};
			else
			    lfsr_q <= valid ? lfsr_c : lfsr_q;
		end
endmodule: crc_bit_sequence