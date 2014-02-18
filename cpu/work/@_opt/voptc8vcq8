library verilog;
use verilog.vl_types.all;
entity rs is
    port(
        clock           : in     vl_logic;
        rs_free         : out    vl_logic;
        rs_lok          : out    vl_logic;
        rs_sok          : out    vl_logic;
        rg_ok           : out    vl_logic;
        rg_num          : in     vl_logic_vector(4 downto 0);
        rg_check        : in     vl_logic;
        in_op           : in     vl_logic_vector(31 downto 0);
        in_address      : in     vl_logic_vector(31 downto 0);
        in_reg          : in     vl_logic_vector(4 downto 0);
        in_reg2         : in     vl_logic_vector(4 downto 0);
        write           : in     vl_logic;
        out_dst         : out    vl_logic_vector(4 downto 0);
        out_dst_data    : out    vl_logic_vector(31 downto 0);
        write_dst       : out    vl_logic;
        in_databus      : in     vl_logic_vector(63 downto 0);
        out_databus     : out    vl_logic_vector(63 downto 0);
        write_databus   : out    vl_logic
    );
end rs;
