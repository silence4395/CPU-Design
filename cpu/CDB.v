`include "DEF.v"
module cdb(databus, data, write, databus2, data2, write2);
  output [63:0] databus, databus2;
  input [63:0] data, data2;
  input write, write2;
  reg [63:0] r_databus, r_databus2;
  assign databus = r_databus;
  assign databus2 = r_databus2;
  
  always @(posedge write)
  begin
    r_databus <= data;
    /*
    $display("CDB!!!!!! %d %d\n", data[63:48], data[31:0]);
    $stop;
    */
  end
  
  always @(posedge write2)
  begin
    r_databus2 <= data2;
    /*
    $display("CDB!!!!!! %d %d\n", data[63:48], data[31:0]);
    $stop;
    */
  end
endmodule