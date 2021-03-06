`include "DEF.v"
/*
DCACHE_BLOCK_SIZE 64*4 byte
DMEMORY_SIZE 26'h4000000 byte
DCACHE_SIZE 16'h10000 byte
*/

module dmemory(address, data, /*enable,*/ read, write);
  input [31:0] address;
  inout [31:0] data;
  //input enable;
  input read, write;
  reg [31:0] dmemory [24'hFFFFFF:0];
  
  assign data = (/*enable &&*/ read) ? dmemory[address] : 32'hz;
  
  /*
  always @(posedge read)
  begin
    if(address === 14999)
    begin
      $display("MREAD!!!!!! %d %d\n", address, dmemory[address]);
      $stop;
    end
  end
  */
  
  always @(posedge write)
  begin
    dmemory[address] <= data;
    /*
    if(address === 14999)
    begin
      $display("MWRITE!!!!! %d %d %d\n", address, address*4, data);
      $stop;
    end
    */
  end
endmodule