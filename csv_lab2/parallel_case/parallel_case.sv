// Code your design here
module parallel_case
  (
    input logic [3 : 0] din,
    output logic [1 : 0] dout
  );
  always_comb
    begin
      case(din) inside
        4'b1???: dout = 2'h3;
        4'b01??: dout = 2'h2;
        4'b001?: dout = 2'h1;
        4'b0001: dout = 2'h0;
        4'b0000: dout = 2'hX;
      endcase  
    end
endmodule: parallel_case