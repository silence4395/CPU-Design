`include "DEF.v"
module ifetch(clock,
              imem_address, imem_data, imem_read,
              pc_address, nxt_address, write_pc,
              out_op1, out_src11, out_src12, out_dst1, out_imm1,
              out_srcn11, out_srcn12, in_src11, in_src12, read_src11, read_src12,
              out_op2, out_src21, out_src22, out_dst2, out_imm2,
              out_srcn21, out_srcn22, in_src21, in_src22, read_src21, read_src22,
              out_op3, out_src31, out_src32, out_dst3, out_imm3,
              out_srcn31, out_srcn32, in_src31, in_src32, read_src31, read_src32,
              out_op4, out_src41, out_src42, out_dst4, out_imm4,
              out_srcn41, out_srcn42, in_src41, in_src42, read_src41, read_src42,
              rg_check_ok, rg_check_num, rg_check, rs_op, rs_address, rs_reg, rs_reg2, rs_write, rs_free, rs_ex_ok, in_databus, in_databus2);
  input clock;
  input [31:0] pc_address;
  input signed [31:0] in_src11, in_src12;
  input signed [31:0] in_src21, in_src22;
  input signed [31:0] in_src31, in_src32;
  input signed [31:0] in_src41, in_src42;
  input signed [127:0] imem_data;
  input [63:0] in_databus, in_databus2;
  input rg_check_ok;
  input rs_free;
  input rs_ex_ok;
  output [31:0] nxt_address;
  output write_pc;
  output [31:0] out_op1, out_op2, out_op3, out_op4;
  output [31:0] out_src11, out_src12;
  output [31:0] out_src21, out_src22;
  output [31:0] out_src31, out_src32;
  output [31:0] out_src41, out_src42;
  output [4:0] out_dst1, out_dst2, out_dst3, out_dst4;
  output [31:0] out_imm1, out_imm2, out_imm3, out_imm4;
  output [4:0] out_srcn11, out_srcn12;
  output [4:0] out_srcn21, out_srcn22;
  output [4:0] out_srcn31, out_srcn32;
  output [4:0] out_srcn41, out_srcn42;
  output read_src11, read_src12;
  output read_src21, read_src22;
  output read_src31, read_src32;
  output read_src41, read_src42;
  output [31:0] imem_address;
  output imem_read;
  output [4:0] rg_check_num;
  output rg_check;
  output [31:0] rs_op, rs_address;
  output [4:0] rs_reg, rs_reg2;
  output rs_write;
  reg [31:0] opcode[3:0];
  reg [4:0] source1[3:0];
  reg [4:0] source2[3:0];
  reg [4:0] destination[3:0];
  reg signed [31:0] immediate[3:0];
  reg [31:0] address;
  reg r_write_pc, r_read_src1[3:0], r_read_src2[3:0];
  reg r_imem_read;
  reg jmp_status;
  reg r_rg_check;
  reg [4:0] r_rg_check_num;
  reg r_rg_check_result;
  reg r_rs_write;
  reg [4:0] r_rs_reg, r_rs_reg2;
  
  assign out_op1 = opcode[0];
  assign out_op2 = opcode[1];
  assign out_op3 = opcode[2];
  assign out_op4 = opcode[3];
  assign out_srcn11 = source1[0];
  assign out_srcn12 = source2[0];
  assign out_srcn21 = source1[1];
  assign out_srcn22 = source2[1];
  assign out_srcn31 = source1[2];
  assign out_srcn32 = source2[2];
  assign out_srcn41 = source1[3];
  assign out_srcn42 = source2[3];
  assign out_src11 = in_src11;
  assign out_src12 = in_src12;
  assign out_src21 = in_src21;
  assign out_src22 = in_src22;
  assign out_src31 = in_src31;
  assign out_src32 = in_src32;
  assign out_src41 = in_src41;
  assign out_src42 = in_src42;
  assign out_dst1 = destination[0];
  assign out_dst2 = destination[1];
  assign out_dst3 = destination[2];
  assign out_dst4 = destination[3];
  assign out_imm1 = immediate[0];
  assign out_imm2 = immediate[1];
  assign out_imm3 = immediate[2];
  assign out_imm4 = immediate[3];
  assign imem_address = pc_address;
  assign nxt_address = address;
  assign write_pc = r_write_pc;
  assign read_src11 = r_read_src1[0];
  assign read_src12 = r_read_src2[0];
  assign read_src21 = r_read_src1[1];
  assign read_src22 = r_read_src2[1];
  assign read_src31 = r_read_src1[2];
  assign read_src32 = r_read_src2[2];
  assign read_src41 = r_read_src1[3];
  assign read_src42 = r_read_src2[3];
  assign imem_read = r_imem_read;
  assign rg_check = r_rg_check;
  assign rg_check_num = r_rg_check_num;
  assign rs_write = r_rs_write;
  assign rs_reg = r_rs_reg;
  assign rs_reg2 = r_rs_reg2;
  assign rs_address = immediate[3];
  assign rs_op = opcode[3];
  
  task check_source10;
    begin
      #0.001
      r_rg_check <= 0;
      r_rg_check_num <= source1[0];
      #0.001 r_rg_check <= 1;
      #0.001 r_rg_check_result <= r_rg_check_result | rg_check_ok;
    end
  endtask
  
  task check_source11;
    begin
      #0.001
      r_rg_check <= 0;
      r_rg_check_num <= source1[1];
      #0.001 r_rg_check <= 1;
      #0.001 r_rg_check_result <= r_rg_check_result | rg_check_ok;
    end
  endtask
  
  task check_source12;
    begin
      #0.001
      r_rg_check <= 0;
      r_rg_check_num <= source1[2];
      #0.001 r_rg_check <= 1;
      #0.001 r_rg_check_result <= r_rg_check_result | rg_check_ok;
    end
  endtask
  
  task check_source13;
    begin
      #0.001
      r_rg_check <= 0;
      r_rg_check_num <= source1[3];
      #0.001 r_rg_check <= 1;
      #0.001 r_rg_check_result <= r_rg_check_result | rg_check_ok;
    end
  endtask
  
  task check_source20;
    begin
      #0.001
      r_rg_check <= 0;
      r_rg_check_num <= source2[0];
      #0.001 r_rg_check <= 1;
      #0.001 r_rg_check_result <= r_rg_check_result | rg_check_ok;
    end
  endtask
  
  task check_source21;
    begin
      #0.001
      r_rg_check <= 0;
      r_rg_check_num <= source2[1];
      #0.001 r_rg_check <= 1;
      #0.001 r_rg_check_result <= r_rg_check_result | rg_check_ok;
    end
  endtask
  
  task check_source22;
    begin
      #0.001
      r_rg_check <= 0;
      r_rg_check_num <= source2[2];
      #0.001 r_rg_check <= 1;
      #0.001 r_rg_check_result <= r_rg_check_result | rg_check_ok;
    end
  endtask
  
  task check_source23;
    begin
      #0.001
      r_rg_check <= 0;
      r_rg_check_num <= source2[3];
      #0.001 r_rg_check <= 1;
      #0.001 r_rg_check_result <= r_rg_check_result | rg_check_ok;
    end
  endtask
  
  task check_destination0;
    begin
      #0.001
      r_rg_check <= 0;
      r_rg_check_num <= destination[0];
      #0.001 r_rg_check <= 1;
      #0.001 r_rg_check_result <= r_rg_check_result | rg_check_ok;
    end
  endtask
  
  task check_destination1;
    begin
      #0.001
      r_rg_check <= 0;
      r_rg_check_num <= destination[1];
      #0.001 r_rg_check <= 1;
      #0.001 r_rg_check_result <= r_rg_check_result | rg_check_ok;
    end
  endtask
  
  task check_destination2;
    begin
      #0.001
      r_rg_check <= 0;
      r_rg_check_num <= destination[2];
      #0.001 r_rg_check <= 1;
      #0.001 r_rg_check_result <= r_rg_check_result | rg_check_ok;
    end
  endtask
  
  task check_destination3;
    begin
      #0.001
      r_rg_check <= 0;
      r_rg_check_num <= destination[3];
      #0.001 r_rg_check <= 1;
      #0.001 r_rg_check_result <= r_rg_check_result | rg_check_ok;
    end
  endtask
  
  always @(posedge clock)
  begin
    r_rs_write <= 0;
    if(in_databus[63:48] !== 16'b100000_00000_00000 &&
       in_databus2[63:48] !== 16'b100000_00000_00000)
    begin
    r_imem_read <= 0;
    #0.010
    r_read_src1[0] <= 1;
    r_read_src2[0] <= 1;
    r_read_src1[1] <= 1;
    r_read_src2[1] <= 1;
    r_read_src1[2] <= 1;
    r_read_src2[2] <= 1;
    r_read_src1[3] <= 1;
    r_read_src2[3] <= 1;
    r_imem_read <= 1;
    
    jmp_status <= 0;
    r_rg_check_result <= 0;
    
    /*
    #0.001
    $display("%d %d\n", pc_address, imem_data);
    $stop;
    */
    
    #0.010 casex(imem_data[31:0])
      /* //nop
      32'b000000_00000_00000_00000_00000_000000:
      begin
        opcode <= 0;
        r_write_pc <= 0;
        address <= pc_address + 1;
        #0.010 r_write_pc <= 1;
      end
      */
      32'b000000_xxxxx_xxxxx_xxxxx_xxxxx_000000: /* sll rt rd shamt */
      begin
        opcode[0] <= 1;
        source2[0] <= imem_data[20:16];
        destination[0] <= imem_data[15:11];
        immediate[0] <= imem_data[10:6];
        check_source20;
        check_destination0;
      end
      32'b000000_xxxxx_xxxxx_xxxxx_00000_100000: /* add rs rt rd */
      begin
        opcode[0] <= 6;
        source1[0] <= imem_data[25:21];
        source2[0] <= imem_data[20:16];
        destination[0] <= imem_data[15:11];
        check_source10;
        check_source20;
        check_destination0;
      end
      32'b000000_xxxxx_000000000000000_001000: /* jr rs */
      begin
        opcode[0] <= 7;
        source1[0] <= imem_data[25:21];
        #0.010 address <= in_src11;
        jmp_status <= 1;
        check_source10;
      end
      32'b000010_xxxxxxxxxxxxxxxxxxxxxxxxxx: /* j target */
      begin
        opcode[0] <= 11;
        immediate[0] <= imem_data[25:0];
        address <= imem_data[25:0];
        jmp_status <= 1;
      end
      32'b000011_xxxxxxxxxxxxxxxxxxxxxxxxxx: /* jal target */
      begin
        opcode[0] <= 14;
        immediate[0] <= pc_address + 1;
        destination[0] <= 31;
        address <= imem_data[25:0];
        jmp_status <= 1;
        check_destination0;
      end
      32'b001000_xxxxx_xxxxx_xxxxxxxxxxxxxxxx: /* addi rs rt imm */
      begin
        opcode[0] <= 2;
        source1[0] <= imem_data[25:21];
        destination[0] <= imem_data[20:16];
        immediate[0] <= imem_data[15:0];
        check_source10;
        check_destination0;
      end
      32'b011000_xxxxx_xxxxx_xxxxx_00000000000: /* mul rs rt rd */
      begin
        opcode[0] <= 3;
        source1[0] <= imem_data[25:21];
        source2[0] <= imem_data[20:16];
        destination[0] <= imem_data[15:11];
        /*
        #0.001 $display("MUL IF !!!! %d %d %d\n", source1[0], source2[0], destination[0]);
        $stop;
        */
        check_source10;
        check_source20;
        check_destination0;
      end
      32'b001111_00000_xxxxx_xxxxxxxxxxxxxxxx: /* lui rt imm */
      begin
        opcode[0] <= 16;
        destination[0] <= imem_data[20:16];
        immediate[0] <= imem_data[15:0];
        check_destination0;
      end
      32'b011011_xxxxx_xxxxx_xxxxxxxxxxxxxxxx: /* muli rs rt imm */
      begin
        opcode[0] <= 13;
        source1[0] <= imem_data[25:21];
        destination[0] <= imem_data[20:16];
        immediate[0] <= imem_data[15:0];
        check_source10;
        check_destination0;
      end
      32'b001101_xxxxx_xxxxx_xxxxxxxxxxxxxxxx: /* ori rs rt imm */
      begin
        opcode[0] <= 15;
        source1[0] <= imem_data[25:21];
        destination[0] <= imem_data[20:16];
        immediate[0] <= imem_data[15:0];
        check_source10;
        check_destination0;
      end
      32'b011001_xxxxx_xxxxx_000000000000000_0: /* move rs rt */
      begin
        opcode[0] <= 4;
        source1[0] <= imem_data[25:21];
        destination[0] <= imem_data[20:16];
        check_source10;
        check_destination0;
      end
      32'b011001_xxxxx_xxxxxxxxxxxxxxxxxxxx_1: /* movei rs imm */
      begin
        opcode[0] <= 5;
        destination[0] <= imem_data[25:21];
        immediate[0] <= imem_data[20:1];
        check_destination0;
      end
      32'b011010_xxxxx_xxxxx_xxxxxxxxxxxxxxxx: /* bge rs rt offset */
      begin
        opcode[0] <= 8;
        source1[0] <= imem_data[25:21];
        source2[0] <= imem_data[20:16];
        immediate[0] <= imem_data[15:0];
        #0.010 if(in_src11 >= in_src12)
        begin
          address <= imem_data[15:15] == 1 ? pc_address - (~{16'b1111111111111111, imem_data[15:0]}+1) + 1 : pc_address + {16'b0, imem_data[15:0]} + 1;
          jmp_status <= 1;
        end
        check_source10;
        check_source20;
      end
      32'b100011_xxxxx_xxxxx_xxxxxxxxxxxxxxxx: /* lw rs rt offset */
      begin
        opcode[0] <= 9;
        destination[0] <= imem_data[20:16];
        source1[0] <= imem_data[25:21];
        #0.010 immediate[0] <= imem_data[15:15] == 1 ? in_src11/4 - (~{16'b1111111111111111, imem_data[15:0]}+1) : in_src11/4 + {16'b0, imem_data[15:0]};
        check_source10;
        check_destination0;
      end
      32'b101011_xxxxx_xxxxx_xxxxxxxxxxxxxxxx: /* sw rs rt offset */
      begin
        opcode[0] <= 10;
        source1[0] <= imem_data[25:21];
        source2[0] <= imem_data[20:16];
        #0.010
        immediate[0] <= imem_data[15:15] == 1 ? in_src11/32'h4 - (~{16'b1111111111111111, imem_data[15:0]}+32'h1) : in_src11/32'h4 + {16'b0, imem_data[15:0]};
        check_source10;
        check_source20;
      end
      32'b111111_11111_11111_1111111111111111: /* halt */
      begin
        opcode[0] <= 12;
        address <= pc_address;
        jmp_status <= 1;
      end
      default:
      begin
        opcode[0] <= 0;
      end
    endcase
    
    #0.010 casex(imem_data[31+32:0+32])
      /* //nop
      32'b000000_00000_00000_00000_00000_000000:
      begin
        opcode <= 0;
        r_write_pc <= 0;
        address <= pc_address + 1;
        #0.010 r_write_pc <= 1;
      end
      */
      32'b000000_xxxxx_xxxxx_xxxxx_xxxxx_000000: /* sll rt rd shamt */
      begin
        opcode[1] <= 1;
        source2[1] <= imem_data[20+32:16+32];
        destination[1] <= imem_data[15+32:11+32];
        immediate[1] <= imem_data[10+32:6+32];
        check_source21;
        check_destination1;
      end
      32'b000000_xxxxx_xxxxx_xxxxx_00000_100000: /* add rs rt rd */
      begin
        opcode[1] <= 6;
        source1[1] <= imem_data[25+32:21+32];
        source2[1] <= imem_data[20+32:16+32];
        destination[1] <= imem_data[15+32:11+32];
        check_source11;
        check_source21;
        check_destination1;
      end
      32'b000000_xxxxx_000000000000000_001000: /* jr rs */
      begin
        opcode[1] <= 7;
        source1[1] <= imem_data[25+32:21+32];
        #0.010 address <= in_src21;
        jmp_status <= 1;
        check_source11;
      end
      32'b000010_xxxxxxxxxxxxxxxxxxxxxxxxxx: /* j target */
      begin
        opcode[1] <= 11;
        immediate[1] <= imem_data[25+32:0+32];
        address <= imem_data[25+32:0+32];
        jmp_status <= 1;
      end
      32'b000011_xxxxxxxxxxxxxxxxxxxxxxxxxx: /* jal target */
      begin
        opcode[1] <= 14;
        immediate[1] <= pc_address + 1;
        destination[1] <= 31;
        address <= imem_data[25+32:0+32];
        jmp_status <= 1;
        check_destination1;
      end
      32'b001000_xxxxx_xxxxx_xxxxxxxxxxxxxxxx: /* addi rs rt imm */
      begin
        opcode[1] <= 2;
        source1[1] <= imem_data[25+32:21+32];
        destination[1] <= imem_data[20+32:16+32];
        immediate[1] <= imem_data[15+32:0+32];
        check_source11;
        check_destination1;
      end
      32'b011000_xxxxx_xxxxx_xxxxx_00000000000: /* mul rs rt rd */
      begin
        opcode[1] <= 3;
        source1[1] <= imem_data[25+32:21+32];
        source2[1] <= imem_data[20+32:16+32];
        destination[1] <= imem_data[15+32:11+32];
        /*
        #0.001 $display("MUL IF !!!! %d %d %d\n", source1[1], source2[1], destination[1]);
        $stop;
        */
        check_source11;
        check_source21;
        check_destination1;
      end
      32'b001111_00000_xxxxx_xxxxxxxxxxxxxxxx: /* lui rt imm */
      begin
        opcode[1] <= 16;
        destination[1] <= imem_data[20+32:16+32];
        immediate[1] <= imem_data[15+32:0+32];
        check_destination1;
      end
      32'b011011_xxxxx_xxxxx_xxxxxxxxxxxxxxxx: /* muli rs rt imm */
      begin
        opcode[1] <= 13;
        source1[1] <= imem_data[25+32:21+32];
        destination[1] <= imem_data[20+32:16+32];
        immediate[1] <= imem_data[15+32:0+32];
        check_source11;
        check_destination1;
      end
      32'b001101_xxxxx_xxxxx_xxxxxxxxxxxxxxxx: /* ori rs rt imm */
      begin
        opcode[1] <= 15;
        source1[1] <= imem_data[25+32:21+32];
        destination[1] <= imem_data[20+32:16+32];
        immediate[1] <= imem_data[15+32:0+32];
        check_source11;
        check_destination1;
      end
      32'b011001_xxxxx_xxxxx_000000000000000_0: /* move rs rt */
      begin
        opcode[1] <= 4;
        source1[1] <= imem_data[25+32:21+32];
        destination[1] <= imem_data[20+32:16+32];
        check_source11;
        check_destination1;
      end
      32'b011001_xxxxx_xxxxxxxxxxxxxxxxxxxx_1: /* movei rs imm */
      begin
        opcode[1] <= 5;
        destination[1] <= imem_data[25+32:21+32];
        immediate[1] <= imem_data[20+32:1+32];
        check_destination1;
      end
      32'b011010_xxxxx_xxxxx_xxxxxxxxxxxxxxxx: /* bge rs rt offset */
      begin
        opcode[1] <= 8;
        source1[1] <= imem_data[25+32:21+32];
        source2[1] <= imem_data[20+32:16+32];
        immediate[1] <= imem_data[15+32:0+32];
        #0.010 if(in_src21 >= in_src22)
        begin
          address <= imem_data[15+32:15+32] == 1 ? pc_address - (~{16'b1111111111111111, imem_data[15+32:0+32]}+1) + 1 : pc_address + {16'b0, imem_data[15+32:0+32]} + 1;
          jmp_status <= 1;
        end
        check_source11;
        check_source21;
      end
      32'b100011_xxxxx_xxxxx_xxxxxxxxxxxxxxxx: /* lw rs rt offset */
      begin
        opcode[1] <= 9;
        destination[1] <= imem_data[20+32:16+32];
        source1[1] <= imem_data[25+32:21+32];
        #0.010 immediate[1] <= imem_data[15+32:15+32] == 1 ? in_src21/4 - (~{16'b1111111111111111, imem_data[15+32:0+32]}+1) : in_src21/4 + {16'b0, imem_data[15+32:0+32]};
        check_source11;
        check_destination1;
      end
      32'b101011_xxxxx_xxxxx_xxxxxxxxxxxxxxxx: /* sw rs rt offset */
      begin
        opcode[1] <= 10;
        source1[1] <= imem_data[25+32:21+32];
        source2[1] <= imem_data[20+32:16+32];
        #0.010
        immediate[1] <= imem_data[15+32:15+32] == 1 ? in_src21/32'h4 - (~{16'b1111111111111111, imem_data[15+32:0+32]}+32'h1) : in_src21/32'h4 + {16'b0, imem_data[15+32:0+32]};
        check_source11;
        check_source21;
      end
      32'b111111_11111_11111_1111111111111111: /* halt */
      begin
        opcode[1] <= 12;
        address <= pc_address;
        jmp_status <= 1;
      end
      default:
      begin
        opcode[1] <= 0;
      end
    endcase
    
    #0.010 casex(imem_data[31+64:0+64])
      /* //nop
      32'b000000_00000_00000_00000_00000_000000:
      begin
        opcode <= 0;
        r_write_pc <= 0;
        address <= pc_address + 1;
        #0.010 r_write_pc <= 1;
      end
      */
      32'b000000_xxxxx_xxxxx_xxxxx_xxxxx_000000: /* sll rt rd shamt */
      begin
        opcode[2] <= 1;
        source2[2] <= imem_data[20+64:16+64];
        destination[2] <= imem_data[15+64:11+64];
        immediate[2] <= imem_data[10+64:6+64];
        check_source22;
        check_destination2;
      end
      32'b000000_xxxxx_xxxxx_xxxxx_00000_100000: /* add rs rt rd */
      begin
        opcode[2] <= 6;
        source1[2] <= imem_data[25+64:21+64];
        source2[2] <= imem_data[20+64:16+64];
        destination[2] <= imem_data[15+64:11+64];
        check_source12;
        check_source22;
        check_destination2;
      end
      32'b000000_xxxxx_000000000000000_001000: /* jr rs */
      begin
        opcode[2] <= 7;
        source1[2] <= imem_data[25+64:21+64];
        #0.010 address <= in_src31;
        jmp_status <= 1;
        check_source12;
      end
      32'b000010_xxxxxxxxxxxxxxxxxxxxxxxxxx: /* j target */
      begin
        opcode[2] <= 11;
        immediate[2] <= imem_data[25+64:0+64];
        address <= imem_data[25+64:0+64];
        jmp_status <= 1;
      end
      32'b000011_xxxxxxxxxxxxxxxxxxxxxxxxxx: /* jal target */
      begin
        opcode[2] <= 14;
        immediate[2] <= pc_address + 1;
        destination[2] <= 31;
        address <= imem_data[25+64:0+64];
        jmp_status <= 1;
        check_destination2;
      end
      32'b001000_xxxxx_xxxxx_xxxxxxxxxxxxxxxx: /* addi rs rt imm */
      begin
        opcode[2] <= 2;
        source1[2] <= imem_data[25+64:21+64];
        destination[2] <= imem_data[20+64:16+64];
        immediate[2] <= imem_data[15+64:0+64];
        check_source12;
        check_destination2;
      end
      32'b011000_xxxxx_xxxxx_xxxxx_00000000000: /* mul rs rt rd */
      begin
        opcode[2] <= 3;
        source1[2] <= imem_data[25+64:21+64];
        source2[2] <= imem_data[20+64:16+64];
        destination[2] <= imem_data[15+64:11+64];
        /*
        #0.001 $display("MUL IF !!!! %d %d %d\n", source1[2], source2[2], destination[2]);
        $stop;
        */
        check_source12;
        check_source22;
        check_destination2;
      end
      32'b001111_00000_xxxxx_xxxxxxxxxxxxxxxx: /* lui rt imm */
      begin
        opcode[2] <= 16;
        destination[2] <= imem_data[20+64:16+64];
        immediate[2] <= imem_data[15+64:0+64];
        check_destination2;
      end
      32'b011011_xxxxx_xxxxx_xxxxxxxxxxxxxxxx: /* muli rs rt imm */
      begin
        opcode[2] <= 13;
        source1[2] <= imem_data[25+64:21+64];
        destination[2] <= imem_data[20+64:16+64];
        immediate[2] <= imem_data[15+64:0+64];
        check_source12;
        check_destination2;
      end
      32'b001101_xxxxx_xxxxx_xxxxxxxxxxxxxxxx: /* ori rs rt imm */
      begin
        opcode[2] <= 15;
        source1[2] <= imem_data[25+64:21+64];
        destination[2] <= imem_data[20+64:16+64];
        immediate[2] <= imem_data[15+64:0+64];
        check_source12;
        check_destination2;
      end
      32'b011001_xxxxx_xxxxx_000000000000000_0: /* move rs rt */
      begin
        opcode[2] <= 4;
        source1[2] <= imem_data[25+64:21+64];
        destination[2] <= imem_data[20+64:16+64];
        check_source12;
        check_destination2;
      end
      32'b011001_xxxxx_xxxxxxxxxxxxxxxxxxxx_1: /* movei rs imm */
      begin
        opcode[2] <= 5;
        destination[2] <= imem_data[25+64:21+64];
        immediate[2] <= imem_data[20+64:1+64];
        check_destination2;
      end
      32'b011010_xxxxx_xxxxx_xxxxxxxxxxxxxxxx: /* bge rs rt offset */
      begin
        opcode[2] <= 8;
        source1[2] <= imem_data[25+64:21+64];
        source2[2] <= imem_data[20+64:16+64];
        immediate[2] <= imem_data[15+64:0+64];
        #0.010 if(in_src31 >= in_src32)
        begin
          address <= imem_data[15+64:15+64] == 1 ? pc_address - (~{16'b1111111111111111, imem_data[15+64:0+64]}+1) + 1 : pc_address + {16'b0, imem_data[15+64:0+64]} + 1;
          jmp_status <= 1;
        end
        check_source12;
        check_source22;
      end
      32'b100011_xxxxx_xxxxx_xxxxxxxxxxxxxxxx: /* lw rs rt offset */
      begin
        opcode[2] <= 9;
        destination[2] <= imem_data[20+64:16+64];
        source1[2] <= imem_data[25+64:21+64];
        #0.010 immediate[2] <= imem_data[15+64:15+64] == 1 ? in_src31/4 - (~{16'b1111111111111111, imem_data[15+64:0+64]}+1) : in_src31/4 + {16'b0, imem_data[15+64:0+64]};
        check_source12;
        check_destination2;
      end
      32'b101011_xxxxx_xxxxx_xxxxxxxxxxxxxxxx: /* sw rs rt offset */
      begin
        opcode[2] <= 10;
        source1[2] <= imem_data[25+64:21+64];
        source2[2] <= imem_data[20+64:16+64];
        #0.010
        immediate[2] <= imem_data[15+64:15+64] == 1 ? in_src31/32'h4 - (~{16'b1111111111111111, imem_data[15+64:0+64]}+32'h1) : in_src31/32'h4 + {16'b0, imem_data[15+64:0+64]};
        check_source12;
        check_source22;
      end
      32'b111111_11111_11111_1111111111111111: /* halt */
      begin
        opcode[2] <= 12;
        address <= pc_address;
        jmp_status <= 1;
      end
      default:
      begin
        opcode[2] <= 0;
      end
    endcase
    
    #0.010 casex(imem_data[31+96:0+96])
      /* //nop
      32'b000000_00000_00000_00000_00000_000000:
      begin
        opcode <= 0;
        r_write_pc <= 0;
        address <= pc_address + 1;
        #0.010 r_write_pc <= 1;
      end
      */
      32'b000000_xxxxx_xxxxx_xxxxx_xxxxx_000000: /* sll rt rd shamt */
      begin
        opcode[3] <= 1;
        source2[3] <= imem_data[20+96:16+96];
        destination[3] <= imem_data[15+96:11+96];
        immediate[3] <= imem_data[10+96:6+96];
        check_source23;
        check_destination3;
      end
      32'b000000_xxxxx_xxxxx_xxxxx_00000_100000: /* add rs rt rd */
      begin
        opcode[3] <= 6;
        source1[3] <= imem_data[25+96:21+96];
        source2[3] <= imem_data[20+96:16+96];
        destination[3] <= imem_data[15+96:11+96];
        check_source13;
        check_source23;
        check_destination3;
      end
      32'b000000_xxxxx_000000000000000_001000: /* jr rs */
      begin
        opcode[3] <= 7;
        source1[3] <= imem_data[25+96:21+96];
        #0.010 address <= in_src41;
        jmp_status <= 1;
        check_source13;
      end
      32'b000010_xxxxxxxxxxxxxxxxxxxxxxxxxx: /* j target */
      begin
        opcode[3] <= 11;
        immediate[3] <= imem_data[25+96:0+96];
        address <= imem_data[25+96:0+96];
        jmp_status <= 1;
      end
      32'b000011_xxxxxxxxxxxxxxxxxxxxxxxxxx: /* jal target */
      begin
        opcode[3] <= 14;
        immediate[3] <= pc_address + 1;
        destination[3] <= 31;
        address <= imem_data[25+96:0+96];
        jmp_status <= 1;
        check_destination3;
      end
      32'b001000_xxxxx_xxxxx_xxxxxxxxxxxxxxxx: /* addi rs rt imm */
      begin
        opcode[3] <= 2;
        source1[3] <= imem_data[25+96:21+96];
        destination[3] <= imem_data[20+96:16+96];
        immediate[3] <= imem_data[15+96:0+96];
        check_source13;
        check_destination3;
      end
      32'b011000_xxxxx_xxxxx_xxxxx_00000000000: /* mul rs rt rd */
      begin
        opcode[3] <= 3;
        source1[3] <= imem_data[25+96:21+96];
        source2[3] <= imem_data[20+96:16+96];
        destination[3] <= imem_data[15+96:11+96];
        /*
        #0.001 $display("MUL IF !!!! %d %d %d\n", source1[3], source2[3], destination[3]);
        $stop;
        */
        check_source13;
        check_source23;
        check_destination3;
      end
      32'b001111_00000_xxxxx_xxxxxxxxxxxxxxxx: /* lui rt imm */
      begin
        opcode[3] <= 16;
        destination[3] <= imem_data[20+96:16+96];
        immediate[3] <= imem_data[15+96:0+96];
        check_destination3;
      end
      32'b011011_xxxxx_xxxxx_xxxxxxxxxxxxxxxx: /* muli rs rt imm */
      begin
        opcode[3] <= 13;
        source1[3] <= imem_data[25+96:21+96];
        destination[3] <= imem_data[20+96:16+96];
        immediate[3] <= imem_data[15+96:0+96];
        check_source13;
        check_destination3;
      end
      32'b001101_xxxxx_xxxxx_xxxxxxxxxxxxxxxx: /* ori rs rt imm */
      begin
        opcode[3] <= 15;
        source1[3] <= imem_data[25+96:21+96];
        destination[3] <= imem_data[20+96:16+96];
        immediate[3] <= imem_data[15+96:0+96];
        check_source13;
        check_destination3;
      end
      32'b011001_xxxxx_xxxxx_000000000000000_0: /* move rs rt */
      begin
        opcode[3] <= 4;
        source1[3] <= imem_data[25+96:21+96];
        destination[3] <= imem_data[20+96:16+96];
        check_source13;
        check_destination3;
      end
      32'b011001_xxxxx_xxxxxxxxxxxxxxxxxxxx_1: /* movei rs imm */
      begin
        opcode[3] <= 5;
        destination[3] <= imem_data[25+96:21+96];
        immediate[3] <= imem_data[20+96:1+96];
        check_destination3;
      end
      32'b011010_xxxxx_xxxxx_xxxxxxxxxxxxxxxx: /* bge rs rt offset */
      begin
        opcode[3] <= 8;
        source1[3] <= imem_data[25+96:21+96];
        source2[3] <= imem_data[20+96:16+96];
        immediate[3] <= imem_data[15+96:0+96];
        #0.010 if(in_src41 >= in_src42)
        begin
          address <= imem_data[15+96:15+96] == 1 ? pc_address - (~{16'b1111111111111111, imem_data[15+96:0+96]}+1) + 1 : pc_address + {16'b0, imem_data[15+96:0+96]} + 1;
          jmp_status <= 1;
        end
        check_source13;
        check_source23;
      end
      32'b100011_xxxxx_xxxxx_xxxxxxxxxxxxxxxx: /* lw rs rt offset */
      begin
        opcode[3] <= 9;
        destination[3] <= imem_data[20+96:16+96];
        source1[3] <= imem_data[25+96:21+96];
        #0.010 immediate[3] <= imem_data[15+96:15+96] == 1 ? in_src41/4 - (~{16'b1111111111111111, imem_data[15+96:0+96]}+1) : in_src41/4 + {16'b0, imem_data[15+96:0+96]};
        check_source13;
        check_destination3;
        
        if(rs_free === 1 /*|| rs_ex_ok === 1*/)
        begin
          r_rs_reg <= source1[3];
          r_rs_reg2 <= destination[3];
          #0.001 r_rs_write <= 1;
        end
        else
        begin
          r_rg_check_result <= 1;
        end
      end
      32'b101011_xxxxx_xxxxx_xxxxxxxxxxxxxxxx: /* sw rs rt offset */
      begin
        opcode[3] <= 10;
        source1[3] <= imem_data[25+96:21+96];
        source2[3] <= imem_data[20+96:16+96];
        #0.010
        immediate[3] <= imem_data[15+96:15+96] == 1 ? in_src41/32'h4 - (~{16'b1111111111111111, imem_data[15+96:0+96]}+32'h1) : in_src41/32'h4 + {16'b0, imem_data[15+96:0+96]};
        check_source13;
        check_source23;
        //#0.001 $display("jiong %d %d\n", r_rg_check_result, rs_free);
        if(rs_free === 1 /*|| rs_ex_ok === 1*/)
        begin
          r_rs_reg <= source1[3];
          r_rs_reg2 <= source2[3];
          #0.001 r_rs_write <= 1;
        end
        else
        begin
          r_rg_check_result <= 1;
        end
      end
      32'b111111_11111_11111_1111111111111111: /* halt */
      begin
        opcode[3] <= 12;
        address <= pc_address;
        jmp_status <= 1;
      end
      default:
      begin
        opcode[3] <= 0;
      end
    endcase
    r_write_pc <= 0;
    #0.010
    /*
    $display("rg_check_result: %d %d %d %d %d %d %d\n", r_rg_check_result, opcode[0], opcode[1], opcode[2], opcode[3], rs_free, jmp_status);
    $stop;
    */
    /*
    if(r_rg_check_result === 1)
    begin
      opcode[0] <= 0;
      opcode[1] <= 0;
      opcode[2] <= 0;
      opcode[3] <= 0;
      address <= pc_address;
      #0.010
      r_write_pc <= 1;
    end
    else
    begin
    */
      if(jmp_status !== 1)
      begin
        address <= pc_address + 1;
      end
      #0.010
      r_write_pc <= 1;
    /*
    end
    */
    end
  end
endmodule
  
