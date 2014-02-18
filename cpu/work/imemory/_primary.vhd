library verilog;
use verilog.vl_types.all;
entity imemory is
    port(
        address         : in     vl_logic_vector(31 downto 0);
        data            : out    vl_logic_vector(127 downto 0);
        read            : in     vl_logic
    );
end imemory;
