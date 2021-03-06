`include "DEF.v"
module register(data1, reg_number1, /*enable1,*/ read1,
                data2, reg_number2, /*enable2,*/ read2,
                data3, reg_number3, /*enable3,*/ write3,
                data4, reg_number4, /*enable1,*/ read4,
                data5, reg_number5, /*enable2,*/ read5,
                data6, reg_number6, /*enable3,*/ write6,
                data7, reg_number7, /*enable1,*/ read7,
                data8, reg_number8, /*enable2,*/ read8,
                data9, reg_number9, /*enable3,*/ write9,
                data10, reg_number10, /*enable1,*/ read10,
                data11, reg_number11, /*enable2,*/ read11,
                data12, reg_number12, /*enable3,*/ write12,
                data13, reg_number13, write13
                );
  output [31:0] data1, data2, data4, data5, data7, data8, data10, data11;
  input [31:0] data3, data6, data9, data12, data13;
  input [4:0] reg_number1, reg_number2, reg_number3, reg_number4, reg_number5, reg_number6,
              reg_number7, reg_number8, reg_number9, reg_number10, reg_number11, reg_number12,
              reg_number13;
  //input enable1, enable2, enable3;
  input read1, read2, read4, read5, read7, read8, read10, read11;
  input write3, write6, write9, write12, write13;
  
  reg signed [31:0] register [31:0];
  
  assign data1 = (/*enable1 &&*/ read1) ? register[reg_number1] : 32'hz;
  assign data2 = (/*enable2 &&*/ read2) ? register[reg_number2] : 32'hz;
  assign data4 = (/*enable1 &&*/ read4) ? register[reg_number4] : 32'hz;
  assign data5 = (/*enable2 &&*/ read5) ? register[reg_number5] : 32'hz;
  assign data7 = (/*enable1 &&*/ read7) ? register[reg_number7] : 32'hz;
  assign data8 = (/*enable2 &&*/ read8) ? register[reg_number8] : 32'hz;
  assign data10 = (/*enable1 &&*/ read10) ? register[reg_number10] : 32'hz;
  assign data11 = (/*enable2 &&*/ read11) ? register[reg_number11] : 32'hz;
  
  always @(posedge write3)
  begin
    //$display("reg%d data:%d\n", reg_number3, data3);
    /*
    if(data3 === 'bx)
    begin
      $display("reg%d: %d\n", reg_number3, data3);
      $stop;
    end
    */
    /*
    if(reg_number3 === 31)
      $display("reg ra data: %d\n", data3);
    */
    register[reg_number3] <= data3;
  end
  
  always @(posedge write6)
  begin
    //$display("reg%d data:%d\n", reg_number6, data6);
    register[reg_number6] <= data6;
  end
  
  always @(posedge write9)
  begin
    //$display("reg%d data:%d\n", reg_number9, data9);
    register[reg_number9] <= data9;
  end
  
  always @(posedge write12)
  begin
    //$display("reg%d data:%d\n", reg_number12, data12);
    register[reg_number12] <= data12;
  end
  
  always @(posedge write13)
  begin
    //$display("reg%d data:%d\n", reg_number13, data13);
    register[reg_number13] <= data13;
  end
endmodule
