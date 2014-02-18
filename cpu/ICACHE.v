`include "DEF.v"
module icache(clock, address, data, read, out_address, out_data, out_read, in_databus, out_databus, write_databus);
  input clock;
  input [31:0] address;
  input [127:0] out_data;
  input [63:0] in_databus;
  output [127:0] data;
  output [31:0] out_address;
  input read;
  output out_read;
  output [63:0] out_databus;
  output write_databus;
  
  reg [127:0] icache [12'hFFF:0];
  reg [31:0] tag [12'hFFF:0];
  reg [127:0] r_data;
  reg [31:0] r_out_address;
  reg r_out_read;
  reg signed [31:0] r_status;
  reg [63:0] r_out_databus;
  reg r_write_databus;
  integer i;
  
  assign data = r_data;
  assign out_read = r_out_read;
  assign out_address = r_out_address;
  assign out_databus = r_out_databus;
  assign write_databus = r_write_databus;
  
  always @(negedge clock)
  begin
    if(r_status === `DELAY_MEMORY)
    begin
      r_write_databus <= 1;
    end
    #0.001
    r_status = r_status - 1;
    #0.001
    if(r_status <= 0)
    begin
      r_write_databus <= 0;
      if(r_status === 0)
      begin
        if(in_databus[31:0] === 0)
          r_out_databus <= 64'b000000_00000_00000_00000_00000_000000_000000_00000_00000_00000_00000_000000;
        else
          r_out_databus <= in_databus - 1;
      end
      #0.001
      r_write_databus <= 1;
    end
  end
  
  
  always @(posedge read)
  begin
    r_out_read <= 0;
    r_write_databus <= 0;
    if(tag[address % 13'h1000] === address)
    begin
      r_data <= icache[address % 13'h1000];
      r_out_databus <= in_databus;
      r_status <= 0;
    end
    else
    begin
      r_out_read <= 1;
      r_out_address <= address;
      #0.001
      
      icache[address % 13'h1000] <= out_data;
      tag[address % 13'h1000] <= address;
      r_data <= out_data;

      for(i=0; i<64; i=i+1)
      begin
        #0.001
        r_out_address <= address / 64 * 64 + i;
        #0.001
        icache[out_address % 13'h1000] <= out_data;
        tag[out_address % 13'h1000] <= out_address;
      end
      if(in_databus[63:48] === 16'b100000_00000_00000)
        r_out_databus <= in_databus + 1;
      else
        r_out_databus <= 64'b100000_00000_00000_00000_00000_000000_000000_00000_00000_00000_00000_000000;
      r_status <= `DELAY_MEMORY;
      
    end
  end
endmodule