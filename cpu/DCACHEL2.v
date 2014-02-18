/*
Is not working :-(
*/

/*
`include "DEF.v"

module dcachel2(clock, address, data, read, write, rs_ex_ok, out_address, out_data, out_read, out_write, in_databus, out_databus, write_databus);
  input [31:0] address;
  inout [31:0] data, out_data;
  input read, write;
  input [63:0] in_databus;
  input clock;
  output [31:0] out_address;
  output out_read, out_write;
  output [63:0] out_databus;
  output write_databus;
  output rs_ex_ok;
  
  reg [31:0] dcache [19'h7FFFF:0];
  reg [31:0] tag [19'h7FFFF:0];
  reg dirty [19'h7FFFF:0];
  reg [31:0] r_out_address;
  reg [31:0] r_out_data;
  reg r_out_read, r_out_write;
  reg [31:0] r_data;
  reg [63:0] r_out_databus;
  reg r_write_databus;
  reg signed [31:0] r_status;
  reg [31:0] r_address;
  reg r_lw_or_sw;
  reg r_rs_ex_ok;
  integer i;
  
  assign data = r_data;
  assign out_read = r_out_read;
  assign out_write = r_out_write;
  assign out_address = r_out_address;
  assign out_data = r_out_data;
  assign out_databus = r_out_databus;
  assign write_databus = r_write_databus;
  assign rs_ex_ok = r_rs_ex_ok;
  
  always @(negedge clock)
  begin
    if(r_status === `DELAY_MEMORY)
    begin
      r_write_databus <= 1;
    end
    #0.001
    r_status = r_status - 1;
    //#0.001 $display("r_status: %d\n", r_status);
    #0.001
    if(r_status <= 0)
    begin
      r_write_databus <= 0;
        r_out_databus <= 64'b000000_00000_00000_00000_00000_000000_000000_00000_00000_00000_00000_000000;
      #0.001
      r_write_databus <= 1;
    end
  end
  
  always @(posedge read)
  begin
    r_out_read <= 0;
    r_out_write <= 0;
    r_write_databus <= 0;

    if(tag[address % 20'h80000] === address)
    begin
      r_data <= dcache[address % 20'h80000];
      r_out_databus <= 64'b000000_00000_00000_00000_00000_000000_000000_00000_00000_00000_00000_000000;
      r_status <= 1;
      r_address <= address;
      r_lw_or_sw <= 0;
      r_rs_ex_ok <= 1;
    end
    else
    begin
      r_rs_ex_ok <= 0;
      //$display("miss \n");
      //$stop;
      if(dirty[address % 20'h80000] === 1)
      begin
        r_out_address <= tag[address % 20'h80000];
        r_out_data <= dcache[address % 20'h80000];
        #0.001
        r_out_write <= 1;
      end
      #0.001
      r_out_address <= address;
      r_out_write <= 0;
      r_out_data <= 32'hz;
      r_out_read <= 1;
      #0.001

      dcache[address % 20'h80000] <= out_data;
      tag[address % 20'h80000] <= address;
      dirty[address % 20'h80000] <= 0;
      r_data <= out_data;

      for(i=0; i<64; i=i+1)
      begin
        #0.001
        r_out_read <= 0;
        #0.001
        if(dirty[address / 64 * 64 + i] === 1)
        begin
          r_out_address <= tag[(address / 64 * 64 + i) % 20'h80000];
          r_out_data <= dcache[(address / 64 * 64 + i) % 20'h80000];
          #0.001
          r_out_write <= 1;
        end
        #0.001
        r_out_address <= address / 64 * 64 + i;
        r_out_write <= 0;
        r_out_data <= 32'hz;
        r_out_read <= 1;
        #0.001
        dcache[out_address % 20'h80000] <= out_data;
        tag[out_address % 20'h80000] <= out_address;
        dirty[out_address % 20'h80000] <= 0;
      end
      r_out_databus <= 64'b100000_00000_00000_00000_00000_000000_000000_00000_00000_00000_00000_000000;
      //r_out_databus <= 64'b000000_00000_00000_00000_00000_000000_000000_00000_00000_00000_00000_000000;
      r_status <= `DELAY_MEMORY;
      r_address <= address;
      r_lw_or_sw <= 0;
    end
  end
  
  always @(negedge read)
  begin
    r_data <= 32'hz;
  end
  
  always @(posedge write)
  begin
    r_write_databus <= 0;
    if(tag[address % 20'h80000] === address)
    begin
      dcache[address % 20'h80000] <= data;
      dirty[address % 20'h80000] <= 1;
      r_out_databus <= 64'b000000_00000_00000_00000_00000_000000_000000_00000_00000_00000_00000_000000;
      r_status <= 1;
      r_address <= address;
      r_lw_or_sw <= 1;
      r_rs_ex_ok <= 1;
    end
    else
    begin
      r_rs_ex_ok <= 0;
      if(dirty[address % 20'h80000] === 1)
      begin
        r_out_address <= tag[address % 20'h80000];
        r_out_data <= dcache[address % 20'h80000];
        #0.001
        r_out_write <= 1;
      end
      #0.001
      r_out_write <= 0;
      dcache[address % 20'h80000] <= data;
      tag[address % 20'h80000] <= address;
      dirty[address % 20'h80000] <= 0;

      for(i=0; i<64; i=i+1)
      begin
        if(address / 64 * 64 + i !== address)
        begin
        #0.001
        if(dirty[address / 64 * 64 + i] === 1)
        begin
          r_out_address <= tag[(address / 64 * 64 + i) % 20'h80000];
          r_out_data <= dcache[(address / 64 * 64 + i) % 20'h80000];
          #0.001
          r_out_write <= 1;
        end
        #0.001
        r_out_address <= address / 64 * 64 + i;
        r_out_write <= 0;
        r_out_data <= 32'hz;
        r_out_read <= 1;
        #0.001
        dcache[out_address % 20'h80000] <= out_data;
        tag[out_address % 20'h80000] <= out_address;
        dirty[address % 20'h80000] <= 0;
        end
      end
      r_out_databus <= 64'b100000_00000_00000_00000_00000_000000_000000_00000_00000_00000_00000_000000;
      //r_out_databus <= 64'b000000_00000_00000_00000_00000_000000_000000_00000_00000_00000_00000_000000;
      r_status <= `DELAY_MEMORY;
      r_address <= address;
      r_lw_or_sw <= 1;
    end
  end
endmodule
*/
