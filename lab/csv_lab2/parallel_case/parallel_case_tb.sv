// Code your testbench here
// or browse Examples
module testbench();
  logic [3 : 0] din;
  logic [1 : 0] dout;
  //instance module
  
  parallel_case uut
  (
    .din(din),
    .dout(dout)
  );
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars;
      repeat(10)
        begin
          din = $random;
          #5 $display("din = %b, dout = %d", din, dout);
        end
    end
  
endmodule: testbench