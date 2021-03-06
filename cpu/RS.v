`include "DEF.v"
module rs(clock, rs_free, rs_lok, rs_sok, rg_ok, rg_num, rg_check, in_op, in_address, in_reg, in_reg2, write, out_dst, out_dst_data, write_dst, in_databus, out_databus, write_databus);
  input clock;
  input [4:0] rg_num;
  input [31:0] in_op;
  input [31:0] in_address;
  input [4:0] in_reg, in_reg2;
  input rg_check;
  input write;
  input [63:0] in_databus;
  output [4:0] out_dst;
  output [31:0] out_dst_data;
  output write_dst;
  output [63:0] out_databus;
  output write_databus;
  output rs_lok, rs_sok;
  output rs_free;
  output rg_ok;
  reg rs_load_busy [3:0];
  reg [31:0] rs_load_address [3:0];
  reg [4:0] rs_load_reg [3:0];
  reg [4:0] rs_load_reg2 [3:0];
  reg rs_store_busy [3:0];
  reg [31:0] rs_store_address [3:0];
  reg [4:0] rs_store_reg [3:0];
  reg [4:0] rs_store_reg2 [3:0];
  reg [3:0] reg_status [31:0]; /* need to be set to 0 initially */
  reg r_rs_lok, r_rs_sok; /* need to be set to 1 initially */
  reg r_rs_free; /* need to be set to 1 initially */
  reg r_rg_ok;
  
  assign rg_ok = r_rg_ok;
  assign rs_lok = r_rs_lok;
  assign rs_sok = r_rs_sok;
  assign rs_free = r_rs_free;
  
  task update_rsok;
    begin
      if(rs_store_busy[0] === 1 && rs_store_busy[1] === 1 &&
        rs_store_busy[2] === 1 && rs_store_busy[3] === 1)
      begin
        r_rs_sok <= 0;
      end
      else
      begin
        r_rs_sok <= 1;
      end
    
      if(rs_load_busy[0] === 1 && rs_load_busy[1] === 1 &&
        rs_load_busy[2] === 1 && rs_load_busy[3] === 1)
      begin
        r_rs_lok <= 0;
      end
      else
      begin
        r_rs_lok <= 1;
      end
      
      if((rs_store_busy[0] === 0) && (rs_store_busy[1] === 0) &&
         (rs_store_busy[2] === 0) && (rs_store_busy[3] === 0) &&
         (rs_load_busy[0] === 0) && (rs_load_busy[1] === 0) &&
         (rs_load_busy[2] === 0) && (rs_load_busy[3] === 0))
      begin
        r_rs_free <= 1;
      end
      else
      begin
        r_rs_free <= 0;
      end
    end
  endtask
  
  always @(posedge rg_check)
  begin
    if(reg_status[rg_num] === 0)
    begin
      r_rg_ok <= 0;
    end
    else
    begin
      r_rg_ok <= 1; //not ok
    end
  end
  
  always @(posedge clock)
  begin
    /*
    $display("%d %d %d %d %d %d %d %d %d %d [%d %d %d %d]\n", rs_load_busy[0],
      rs_load_busy[1], rs_load_busy[2], rs_load_busy[3],
      rs_store_busy[0], rs_store_busy[1], rs_store_busy[2], rs_store_busy[3], in_databus, in_databus[31:0], rs_store_address[0], rs_store_address[1], rs_store_address[2], rs_store_address[3]);
    
    $display("0:%d  1:%d  2:%d  3:%d  4:%d  5:%d  6:%d  7:%d\n",
      reg_status[0], reg_status[1], reg_status[2], reg_status[3], reg_status[4], reg_status[5], reg_status[6], reg_status[7]);
    $display("8:%d  9:%d  10:%d  11:%d  12:%d  13:%d  14:%d  15:%d\n",
      reg_status[8], reg_status[9], reg_status[10], reg_status[11], reg_status[12], reg_status[13], reg_status[14], reg_status[15]);
    $display("16:%d  17:%d  18:%d  19:%d  20:%d  21:%d  22:%d  23:%d\n",
      reg_status[16], reg_status[17], reg_status[18], reg_status[19], reg_status[20], reg_status[21], reg_status[22], reg_status[23]);
    $display("24:%d  25:%d  26:%d  27:%d  28:%d  29:%d  30:%d  31:%d\n",
      reg_status[24], reg_status[25], reg_status[26], reg_status[27], reg_status[28], reg_status[29], reg_status[30], reg_status[31]);
    */
    if(in_databus[63:48] === 16'b0000_0000_0000_0001)
    begin
      /*$display("got it\n"); $stop;*/
      if(rs_load_busy[0] === 1 && rs_load_address[0] === in_databus[31:0])
      begin
        rs_load_busy[0] <= 0;
        reg_status[rs_load_reg[0]] <= reg_status[rs_load_reg[0]] - 1;
        #0.001 reg_status[rs_load_reg2[0]] <= reg_status[rs_load_reg2[0]] - 1;
      end
      if(rs_load_busy[1] === 1 && rs_load_address[1] === in_databus[31:0])
      begin
        rs_load_busy[1] <= 0;
        reg_status[rs_load_reg[1]] <= reg_status[rs_load_reg[1]] - 1;
        #0.001 reg_status[rs_load_reg2[1]] <= reg_status[rs_load_reg2[1]] - 1;
      end
      if(rs_load_busy[2] === 1 && rs_load_address[2] === in_databus[31:0])
      begin
        rs_load_busy[2] <= 0;
        reg_status[rs_load_reg[2]] <= reg_status[rs_load_reg[2]] - 1;
        #0.001 reg_status[rs_load_reg2[2]] <= reg_status[rs_load_reg2[2]] - 1;
      end
      if(rs_load_busy[3] === 1 && rs_load_address[3] === in_databus[31:0])
      begin
        rs_load_busy[3] <= 0;
        reg_status[rs_load_reg[3]] <= reg_status[rs_load_reg[3]] - 1;
        #0.001 reg_status[rs_load_reg2[3]] <= reg_status[rs_load_reg2[3]] - 1;
      end
    end
    if(in_databus[63:48] === 16'b0000_0000_0000_0010)
    begin
      /*$display("got it!\n"); $stop;*/
      if(rs_store_busy[0] === 1 && rs_store_address[0] === in_databus[31:0])
      begin
        rs_store_busy[0] <= 0;
        reg_status[rs_store_reg[0]] <= reg_status[rs_store_reg[0]] - 1;
        #0.001 reg_status[rs_store_reg2[0]] <= reg_status[rs_store_reg2[0]] - 1;
      end
      if(rs_store_busy[1] === 1 && rs_store_address[1] === in_databus[31:0])
      begin
        rs_store_busy[1] <= 0;
        reg_status[rs_store_reg[1]] <= reg_status[rs_store_reg[1]] - 1;
        #0.001 reg_status[rs_store_reg2[1]] <= reg_status[rs_store_reg2[1]] - 1;
      end
      if(rs_store_busy[2] === 1 && rs_store_address[2] === in_databus[31:0])
      begin
        rs_store_busy[2] <= 0;
        reg_status[rs_store_reg[2]] <= reg_status[rs_store_reg[2]] - 1;
        #0.001 reg_status[rs_store_reg2[2]] <= reg_status[rs_store_reg2[2]] - 1;
      end
      if(rs_store_busy[3] === 1 && rs_store_address[3] === in_databus[31:0])
      begin
        rs_store_busy[3] <= 0;
        reg_status[rs_store_reg[3]] <= reg_status[rs_store_reg[3]] - 1;
        #0.001 reg_status[rs_store_reg2[3]] <= reg_status[rs_store_reg2[3]] - 1;
      end
    end
    #0.001 update_rsok;
  end
  
  always @(posedge write)
  begin
    if(in_op === 9) //lw
    begin
      reg_status[in_reg] <= reg_status[in_reg] + 1;
      #0.001
      reg_status[in_reg2] <= reg_status[in_reg2] + 1;
      if(rs_load_busy[0] === 1)
      begin
        if(rs_load_busy[1] === 1)
        begin
          if(rs_load_busy[2] === 1)
          begin
            rs_load_busy[3] <= 1;
            rs_load_address[3] <= in_address;
            rs_load_reg[3] <= in_reg;
            rs_load_reg2[3] <= in_reg2;
          end
          else
          begin
            rs_load_busy[2] <= 1;
            rs_load_address[2] <= in_address;
            rs_load_reg[2] <= in_reg;
            rs_load_reg2[2] <= in_reg2;
          end
        end
        else
        begin
          rs_load_busy[1] <= 1;
          rs_load_address[1] <= in_address;
          rs_load_reg[1] <= in_reg;
          rs_load_reg2[1] <= in_reg2;
        end
      end
      else
      begin
        rs_load_busy[0] <= 1;
        rs_load_address[0] <= in_address;
        rs_load_reg[0] <= in_reg;
        rs_load_reg2[0] <= in_reg2;
      end
    end
    else if(in_op === 10)
    begin
      reg_status[in_reg] <= reg_status[in_reg] + 1;
      #0.001
      reg_status[in_reg2] <= reg_status[in_reg2] + 1;
      if(rs_store_busy[0] === 1)
      begin
        if(rs_store_busy[1] === 1)
        begin
          if(rs_store_busy[2] === 1)
          begin
            rs_store_busy[3] <= 1;
            rs_store_address[3] <= in_address;
            rs_store_reg[3] <= in_reg;
            rs_store_reg2[3] <= in_reg2;
          end
          else
          begin
            rs_store_busy[2] <= 1;
            rs_store_address[2] <= in_address;
            rs_store_reg[2] <= in_reg;
            rs_store_reg2[2] <= in_reg2;
          end
        end
        else
        begin
          rs_store_busy[1] <= 1;
          rs_store_address[1] <= in_address;
          rs_store_reg[1] <= in_reg;
          rs_store_reg2[1] <= in_reg2;
        end
      end
      else
      begin
        rs_store_busy[0] <= 1;
        rs_store_address[0] <= in_address;
        rs_store_reg[0] <= in_reg;
        rs_store_reg2[0] <= in_reg2;
      end
    end
    else
    begin
      reg_status[in_reg] <= reg_status[in_reg] + 1;
      #0.001
      reg_status[in_reg2] <= reg_status[in_reg2] + 1;
    end
    
    #0.001 update_rsok;
  end
endmodule