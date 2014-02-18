`include "DEF.v"
module pc(pc_address, nxt_address, write/*, reset*/);
  output [31:0] pc_address;
  input [31:0] nxt_address;
  input write/*, reset*/;
  reg [31:0] r_pc_address;
  
  assign pc_address = r_pc_address;
  
  always @(posedge write /*or posedge reset*/)
  begin
    /*if(reset)
      pc_address <= 31'b0;
    else*/
      r_pc_address <= nxt_address;
  end
endmodule