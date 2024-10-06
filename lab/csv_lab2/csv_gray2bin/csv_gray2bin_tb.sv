// Code your testbench here
// or browse Examples
module csv_tb_gray2bin();
    parameter N = 4;
    logic [N - 1 : 0] bin;
    logic [N - 1 : 0] gray;
	logic clk, rst_n;
  
    // instance module
    csv_gray2bin #(.N(N))uut
    (
	.clk(clk),
	.rst_n(rst_n),
    .gray(gray),
    .bin_o(bin)
    );
  
  
    initial
        begin
		    clk = 0;
			rst_n = 1;
			#5 rst_n = 0;
			#2 rst_n = 1;
            repeat(20)
                begin
				    @(negedge clk)
                    gray = $random;
					#5;
                end
        end
    always @ (bin)
        begin
		    $display("gray code: %b  bin code: %b", gray, bin);
	    end
	always #5 clk = ~clk;
endmodule: csv_tb_gray2bin

