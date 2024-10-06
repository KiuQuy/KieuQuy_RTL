// Code your design here
module latch
  #(parameter N = 4)
  (
    input logic ena,
    input logic [N - 1 : 0] in,
    output logic [N - 1 : 0] out
  );
  always_latch
    begin
      if(ena) out <= in;
    end
  
endmodule: latch