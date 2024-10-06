// Code your testbench here
// or browse Examples
module csv_tb_bin2gray();
    parameter N = 4;
    logic [N - 1 : 0] bin;
    logic [N - 1 : 0] gray;
    logic clk, rst_n;
  
  // instance module
    csv_bin2gray #(.N(N))uut
    (
    .bin(bin),
    .gray_o(gray),
    .clk(clk),
    .rst_n(rst_n)
    );
    initial 
        begin
		    clk = 0;
			rst_n = 1;
			#3 rst_n = 0;
			#4 rst_n = 1;
            repeat(50) 
			    begin
				    @(negedge clk)
					bin = $random();
					#5;
				end
        end
    always @ (gray)
        begin
	        $display("bin code: %b  gray code: %b", bin, gray);
	    end
	always #5 clk = ~clk;
endmodule: csv_tb_bin2gray