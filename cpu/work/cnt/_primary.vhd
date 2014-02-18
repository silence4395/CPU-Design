library verilog;
use verilog.vl_types.all;
entity cnt is
    port(
        clock           : in     vl_logic;
        ex1             : in     vl_logic;
        ex2             : in     vl_logic;
        ex3             : in     vl_logic;
        ex4             : in     vl_logic;
        read1           : in     vl_logic;
        read2           : in     vl_logic;
        read3           : in     vl_logic;
        read4           : in     vl_logic
    );
end cnt;
