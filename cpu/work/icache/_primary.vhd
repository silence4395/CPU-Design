library verilog;
use verilog.vl_types.all;
entity icache is
    port(
        clock           : in     vl_logic;
        address         : in     vl_logic_vector(31 downto 0);
        data            : out    vl_logic_vector(127 downto 0);
        read            : in     vl_logic;
        out_address     : out    vl_logic_vector(31 downto 0);
        out_data        : in     vl_logic_vector(127 downto 0);
        out_read        : out    vl_logic;
        in_databus      : in     vl_logic_vector(63 downto 0);
        out_databus     : out    vl_logic_vector(63 downto 0);
        write_databus   : out    vl_logic
    );
end icache;
