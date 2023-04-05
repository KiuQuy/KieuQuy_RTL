// Code your testbench here
// or browse Examples
module testbench();
  logic [3 : 0] din;
  logic [1 : 0] dout;
  logic error;
  //instance module
  
  priority_4to2_encoder uut
  (
    .din(din),
    .dout(dout),
    .error(error)
  );
  
  initial 
    begin
      $dumpfile("dump.vcd");
      $dumpvars;
      repeat(20)
        begin
        din = $random;
          #5;
          $display("time: %t,  din = %b, dout = %d, error = %b", $realtime(), din,dout, error);
          
        end
    end

  
  
endmodule: testbench