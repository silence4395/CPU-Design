`include "DEF.v"
module clock(clk);
  output clk;
  reg clock;
  
  assign clk = clock;
  
  initial
  begin
    clock = 0;
  end
  
  always #0.500
  begin
    clock = ~clock;
  end
endmodule
