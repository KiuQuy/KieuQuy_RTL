// Code your testbench here
// or browse Examples
module test();
  parameter N = 4;
  logic ena;
  logic [N - 1 : 0] in;
  logic [N - 1 : 0] out;
  
  // instance module
  
  latch #(.N(N)) uut
  (
    .ena(ena),
    .in(in),
    .out(out)
  );
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars;
      repeat(10) 
        begin
          in = $random;
          ena = $random;
          #5 $display("ena = %b, in = %b, out = %b", ena, in, out);
        end
    end
  
endmodule: test