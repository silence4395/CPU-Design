module cnt(clock, ex1, ex2, ex3, ex4, read1, read2, read3, read4);
  input clock;
  input ex1, ex2, ex3, ex4;
  input read1, read2, read3, read4;
  real cycle; //should be set to zero
  real instr1, instr2, instr3, instr4; //should be set to zero
  always @(posedge clock)
  begin
    cycle <= cycle + 1;
  end
  always @(posedge ex1)
  begin
    instr1 <= instr1 + 1;
  end
  always @(posedge ex2)
  begin
    instr2 <= instr2 + 1;
  end
  always @(posedge ex3)
  begin
    instr3 <= instr3 + 1;
  end
  always @(posedge ex4)
  begin
    instr4 <= instr4 + 1;
  end
  always @(posedge read1 or posedge read2 or posedge read3 or posedge read4)
  begin
    $display("The number of instructions: %.0f\n", instr1+instr2+instr3+instr4);
    $display("The number of cycles: %.0f\n", cycle);
    $display("IPC(Instructions Per Cycle) = %f\n", (instr1+instr2+instr3+instr4)/cycle);
  end
endmodule