`include "CLOCK.v"
`include "DCACHE.v"
`include "DMEMORY.v"
`include "ICACHE.v"
`include "IMEMORY.v"
`include "EX.v"
`include "IF.v"
`include "PC.v"
`include "REGISTER.v"
`include "DEF.v"
`include "RS.v"
`include "DCACHEL2.v"
`include "ICACHEL2.v"
`include "CNT.v"

module cpu();
  wire clock;
  wire [31:0] pc_address, nxt_address;
  wire [31:0] if_out_op1, if_out_op2, if_out_op3, if_out_op4;
  wire [31:0] if_out_src11, if_out_src12;
  wire [31:0] if_out_src21, if_out_src22;
  wire [31:0] if_out_src31, if_out_src32;
  wire [31:0] if_out_src41, if_out_src42;
  wire [31:0] if_out_imm1, if_out_imm2, if_out_imm3, if_out_imm4;
  wire [4:0] if_out_dst1, if_out_dst2, if_out_dst3, if_out_dst4;
  wire [31:0] if_in_src11, if_in_src12;
  wire [31:0] if_in_src21, if_in_src22;
  wire [31:0] if_in_src31, if_in_src32;
  wire [31:0] if_in_src41, if_in_src42;
  wire [127:0] imem_data;
  wire [31:0] imem_address;
  wire imem_read;
  wire [127:0] imem_out_data;
  wire [31:0] imem_out_address;
  wire imem_out_read;
  wire if_read_src11, if_read_src12;
  wire if_read_src21, if_read_src22;
  wire if_read_src31, if_read_src32;
  wire if_read_src41, if_read_src42;
  wire [4:0] if_out_srcn11, if_out_srcn12;
  wire [4:0] if_out_srcn21, if_out_srcn22;
  wire [4:0] if_out_srcn31, if_out_srcn32;
  wire [4:0] if_out_srcn41, if_out_srcn42;
  wire write_pc;
  wire [31:0] dmem_data, dmem_address;
  wire [31:0] dmem_out_data, dmem_out_address;
  wire [31:0] dmem_out_datal2, dmem_out_addressl2;
  wire [4:0] ex_out_dst1, ex_out_dst2, ex_out_dst3, ex_out_dst4;
  wire [31:0] ex_out_dst_data1, ex_out_dst_data2, ex_out_dst_data3, ex_out_dst_data4;
  wire write_dst1, write_dst2, write_dst3, write_dst4;
  wire dmem_write4, dmem_read4;
  wire dmem_out_write, dmem_out_read;
  wire dmem_out_writel2, dmem_out_readl2;
  wire [63:0] cdb_databus, cdb_data;
  wire [63:0] cdb_databus2, cdb_data2;
  wire cdb_write;
  wire cdb_write2;
  wire [31:0] rs_in_op, rs_in_address;
  wire [4:0] rs_rg_num, rs_in_reg, rs_in_reg2;
  wire rs_rg_ok, rs_rs_free, rs_rg_check, rs_write;
  wire rs_ex_ok;
  wire cnt_ex1, cnt_ex2, cnt_ex3, cnt_ex4;
  wire cnt_read1, cnt_read2, cnt_read3, cnt_read4;
  integer i;
  reg [7:0] tmp [26'h3FFFFFF:0];
  
  clock cpu_clock(.clk(clock));
  //dmemory cpu_dmemory(.address(dmem_address), .data(dmem_data), /*.enable*/.read(dmem_read), .write(dmem_write));
  //dmemory cpu_dmemory(.address(dmem_out_addressl2), .data(dmem_out_datal2), /*.enable*/.read(dmem_out_readl2), .write(dmem_out_writel2));
   dmemory cpu_dmemory(.address(dmem_out_address), .data(dmem_out_data), /*.enable*/.read(dmem_out_read), .write(dmem_out_write));  
  //imemory cpu_imemory(.address(imem_address), .data(imem_data), /*.enable*/.read(imem_read));
  imemory cpu_imemory(.address(imem_out_address), .data(imem_out_data), /*.enable*/.read(imem_out_read));
  excute cpu_excute1(.clock(clock),
                    .in_op(if_out_op1), .in_src1(if_out_src11), .in_src2(if_out_src12),
                    .in_dst(if_out_dst1), .in_imm(if_out_imm1),
                    .out_dst(ex_out_dst1), .out_dst_data(ex_out_dst_data1), .write_dst(write_dst1), .cnt_ex(cnt_ex1), .cnt_read(cnt_read1),
                    /*.dmem_address(dmem_address), .dmem_data(dmem_data),*/ .in_databus(cdb_databus), .in_databus2(cdb_databus2));
  excute cpu_excute2(.clock(clock),
                    .in_op(if_out_op2), .in_src1(if_out_src21), .in_src2(if_out_src22),
                    .in_dst(if_out_dst2), .in_imm(if_out_imm2),
                    .out_dst(ex_out_dst2), .out_dst_data(ex_out_dst_data2), .write_dst(write_dst2), .cnt_ex(cnt_ex2), .cnt_read(cnt_read2),
                    /*.dmem_address(dmem_address), .dmem_data(dmem_data),*/ .in_databus(cdb_databus), .in_databus2(cdb_databus2));
  excute cpu_excute3(.clock(clock),
                    .in_op(if_out_op3), .in_src1(if_out_src31), .in_src2(if_out_src32),
                    .in_dst(if_out_dst3), .in_imm(if_out_imm3),
                    .out_dst(ex_out_dst3), .out_dst_data(ex_out_dst_data3), .write_dst(write_dst3), .cnt_ex(cnt_ex3), .cnt_read(cnt_read3),
                    /*.dmem_address(dmem_address), .dmem_data(dmem_data),*/ .in_databus(cdb_databus), .in_databus2(cdb_databus2));
  excute cpu_excute4(.clock(clock),
                    .in_op(if_out_op4), .in_src1(if_out_src41), .in_src2(if_out_src42),
                    .in_dst(if_out_dst4), .in_imm(if_out_imm4),
                    .out_dst(ex_out_dst4), .out_dst_data(ex_out_dst_data4), .write_dst(write_dst4), .cnt_ex(cnt_ex4), .cnt_read(cnt_read4),
                    .dmem_address(dmem_address), .dmem_data(dmem_data), .dmem_write(dmem_write4), .dmem_read(dmem_read4), .in_databus(cdb_databus), .in_databus2(cdb_databus2));
  ifetch cpu_ifetch(.clock(clock),
                    .imem_address(imem_address), .imem_data(imem_data), .imem_read(imem_read),
                    .pc_address(pc_address), .nxt_address(nxt_address), .write_pc(write_pc),
                    .out_op1(if_out_op1), .out_src11(if_out_src11), .out_src12(if_out_src12), .out_dst1(if_out_dst1), .out_imm1(if_out_imm1),
                    .out_srcn11(if_out_srcn11), .out_srcn12(if_out_srcn12), .in_src11(if_in_src11), .in_src12(if_in_src12), .read_src11(if_read_src11), .read_src12(if_read_src12),
                    .out_op2(if_out_op2), .out_src21(if_out_src21), .out_src22(if_out_src22), .out_dst2(if_out_dst2), .out_imm2(if_out_imm2),
                    .out_srcn21(if_out_srcn21), .out_srcn22(if_out_srcn22), .in_src21(if_in_src21), .in_src22(if_in_src22), .read_src21(if_read_src21), .read_src22(if_read_src22),
                    .out_op3(if_out_op3), .out_src31(if_out_src31), .out_src32(if_out_src32), .out_dst3(if_out_dst3), .out_imm3(if_out_imm3),
                    .out_srcn31(if_out_srcn31), .out_srcn32(if_out_srcn32), .in_src31(if_in_src31), .in_src32(if_in_src32), .read_src31(if_read_src31), .read_src32(if_read_src32),
                    .out_op4(if_out_op4), .out_src41(if_out_src41), .out_src42(if_out_src42), .out_dst4(if_out_dst4), .out_imm4(if_out_imm4),
                    .out_srcn41(if_out_srcn41), .out_srcn42(if_out_srcn42), .in_src41(if_in_src41), .in_src42(if_in_src42), .read_src41(if_read_src41), .read_src42(if_read_src42),
                    .rg_check_ok(rs_rg_ok), .rg_check_num(rs_rg_num), .rg_check(rs_rg_check), .rs_op(rs_in_op), .rs_address(rs_in_address), .rs_reg(rs_in_reg), .rs_reg2(rs_in_reg2), .rs_write(rs_write), .rs_free(rs_rs_free), .rs_ex_ok(rs_ex_ok), .in_databus(cdb_databus), .in_databus2(cdb_databus2));
  register cpu_register(.data1(if_in_src11), .reg_number1(if_out_srcn11), /*.enable1*/.read1(if_read_src11),
                        .data2(if_in_src12), .reg_number2(if_out_srcn12), /*.enable2*/.read2(if_read_src12),
                        .data4(if_in_src21), .reg_number4(if_out_srcn21), /*.enable1*/.read4(if_read_src21),
                        .data5(if_in_src22), .reg_number5(if_out_srcn22), /*.enable2*/.read5(if_read_src22),
                        .data7(if_in_src31), .reg_number7(if_out_srcn31), /*.enable1*/.read7(if_read_src31),
                        .data8(if_in_src32), .reg_number8(if_out_srcn32), /*.enable2*/.read8(if_read_src32),
                        .data10(if_in_src41), .reg_number10(if_out_srcn41), /*.enable1*/.read10(if_read_src41),
                        .data11(if_in_src42), .reg_number11(if_out_srcn42), /*.enable2*/.read11(if_read_src42),
                        .data3(ex_out_dst_data1), .reg_number3(ex_out_dst1), /*.enable3*/.write3(write_dst1),
                        .data6(ex_out_dst_data2), .reg_number6(ex_out_dst2), /*.enable3*/.write6(write_dst2),
                        .data9(ex_out_dst_data3), .reg_number9(ex_out_dst3), /*.enable3*/.write9(write_dst3),
                        .data12(ex_out_dst_data4), .reg_number12(ex_out_dst4), /*.enable3*/.write12(write_dst4)
                        );
  pc cpu_pc(.pc_address(pc_address), .nxt_address(nxt_address), .write(write_pc));
  
  icache cpu_icache(.clock(clock), .address(imem_address), .data(imem_data), .read(imem_read), .out_address(imem_out_address), .out_data(imem_out_data), .out_read(imem_out_read), .in_databus(cdb_databus2), .out_databus(cdb_data2), .write_databus(cdb_write2));
  dcache cpu_dcache(.clock(clock), .address(dmem_address), .data(dmem_data), .read(dmem_read4), .write(dmem_write4), .out_address(dmem_out_address), .out_data(dmem_out_data), .out_read(dmem_out_read), .out_write(dmem_out_write), .rs_ex_ok(rs_ex_ok), .in_databus(cdb_databus), .out_databus(cdb_data), .write_databus(cdb_write));
  cdb cpu_cdb(.databus(cdb_databus), .data(cdb_data), .write(cdb_write), .databus2(cdb_databus2),.data2(cdb_data2), .write2(cdb_write2));
  rs cpu_rs(.clock(clock), .rs_free(rs_rs_free), .rg_ok(rs_rg_ok), .rg_num(rs_rg_num), .rg_check(rs_rg_check), .in_op(rs_in_op), .in_address(rs_in_address), .in_reg(rs_in_reg), .in_reg2(rs_in_reg2), .write(rs_write), .in_databus(cdb_databus));
//  dcachel2 cpu_dcachel2(.clock(clock), .address(dmem_out_address), .data(dmem_out_data), .read(dmem_out_read), .write(dmem_out_write), .out_address(dmem_out_addressl2), .out_data(dmem_out_datal2), .out_read(dmem_out_readl2), .out_write(dmem_out_writel2), .rs_ex_ok(rs_ex_ok), .in_databus(cdb_databus), .out_databus(cdb_data), .write_databus(cdb_write));
  cnt cpu_cnt(.clock(clock), .ex1(cnt_ex1), .ex2(cnt_ex2), .ex3(cnt_ex3), .ex4(cnt_ex4), .read1(cnt_read1), .read2(cnt_read2), .read3(cnt_read3), .read4(cnt_read4));
  task program;
    begin
      cpu_pc.r_pc_address = 0;
      cpu_register.register[0] = 0;
      cpu_register.register[28] = 0;
      for(i=0; i<24'hFFFFFF; i=i+1)
      begin
        tmp[i*4] = 0;
        tmp[i*4+1] = 0;
        tmp[i*4+2] = 0;
        tmp[i*4+3] = 0;
      end
      cpu_rs.r_rs_lok = 0;
      cpu_rs.r_rs_sok = 0;
      cpu_rs.r_rs_free = 1;
      for(i=0; i<32; i=i+1)
      begin
        cpu_rs.reg_status[i] = 0;
      end
      for(i=0; i<4; i=i+1)
      begin
        cpu_rs.rs_load_busy[i] = 0;
        cpu_rs.rs_store_busy[i] = 0;
      end
      $readmemb("program.s", cpu_imemory.imemory);
      $readmemh("ram_data.txt", tmp);
      for(i=0; i<24'hFFFFFF; i=i+1)
      begin
        cpu_dmemory.dmemory[i] = {tmp[i*4+0], tmp[i*4+1], tmp[i*4+2], tmp[i*4+3]};
      end
      //$monitor("mem: %d %d", cpu_dmemory.dmemory[0], cpu_dmemory.dmemory[2]);
      //$monitor("dmem_write: %d\n", dmem_write);
      //$display("%d %d %d\n", cpu_imemory.imemory[0], cpu_imemory.imemory[1], cpu_imemory.imemory[2]);
      //$monitor("register: (pc=%d) %d %d\n", cpu_pc.pc_address, cpu_register.register[0], cpu_register.register[1]);
      //$monitor("if_out_srcn1: %d if_out_srcn2: %d\n", if_out_srcn1, if_out_srcn2);
      //$monitor("if_in_src1: %d if_in_src2: %d\n", if_in_src1, if_in_src2);
      //#1.000;
    end
  endtask
  
  initial
  begin
    program;
  end
  
  always #0.001
  begin
    if(imem_data[127:96] === 32'b111111_11111_11111_1111111111111111 ||
       imem_data[95:64] === 32'b111111_11111_11111_1111111111111111 ||
       imem_data[63:32] === 32'b111111_11111_11111_1111111111111111 ||
       imem_data[31:0] === 32'b111111_11111_11111_1111111111111111)
    begin
      /*
      for(i=0; i<20'h80000; i=i+1)
      begin
        if(cpu_dcachel2.dirty[i] === 1)
        begin
          cpu_dmemory.dmemory[cpu_dcachel2.tag[i]] <= cpu_dcachel2.dcache[i];
          cpu_dcachel2.dirty[i] <= 0;
        end
      end
      */
      for(i=0; i<15'h4000; i=i+1)
      begin
        if(cpu_dcache.dirty[i] === 1)
        begin
          cpu_dmemory.dmemory[cpu_dcache.tag[i]] <= cpu_dcache.dcache[i];
          cpu_dcache.dirty[i] <= 0;
        end
      end
      #0.001
      $display("writing to file...\n");
      $writememh("output.d", cpu_dmemory.dmemory);
      #1.000;
    end
  end
endmodule
  