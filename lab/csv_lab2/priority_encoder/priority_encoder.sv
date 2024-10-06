// use if/else statement
module priority_4to2_encoder
  (
    input logic [3 : 0] din,
    output logic [1 : 0] dout,
    output logic       error
  ); 
  always_comb 
    begin
      error = 0;
      if(din[3]) dout = 2'h3;
      else if (din[2]) dout = 2'h2;
      else if (din[1]) dout = 2'h1;
      else if (din[0]) dout = 2'h0;
      else
        begin
          dout = 2'b0;
          error = 1;
        end
    end
endmodule: priority_4to2_encoder