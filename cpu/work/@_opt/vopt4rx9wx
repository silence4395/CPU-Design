library verilog;
use verilog.vl_types.all;
entity excute is
    port(
        clock           : in     vl_logic;
        in_op           : in     vl_logic_vector(31 downto 0);
        in_src1         : in     vl_logic_vector(31 downto 0);
        in_src2         : in     vl_logic_vector(31 downto 0);
        in_dst          : in     vl_logic_vector(4 downto 0);
        in_imm          : in     vl_logic_vector(31 downto 0);
        out_dst         : out    vl_logic_vector(4 downto 0);
        out_dst_data    : out    vl_logic_vector(31 downto 0);
        write_dst       : out    vl_logic;
        dmem_address    : out    vl_logic_vector(31 downto 0);
        dmem_data       : inout  vl_logic_vector(31 downto 0);
        dmem_write      : out    vl_logic;
        dmem_read       : out    vl_logic;
        cnt_ex          : out    vl_logic;
        cnt_read        : out    vl_logic;
        in_databus      : in     vl_logic_vector(63 downto 0);
        in_databus2     : in     vl_logic_vector(63 downto 0)
    );
end excute;
