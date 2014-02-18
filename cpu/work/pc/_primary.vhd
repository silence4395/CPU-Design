library verilog;
use verilog.vl_types.all;
entity pc is
    port(
        pc_address      : out    vl_logic_vector(31 downto 0);
        nxt_address     : in     vl_logic_vector(31 downto 0);
        write           : in     vl_logic
    );
end pc;
