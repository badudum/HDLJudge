library ieee;
use ieee.std_logic_1164.all;

entity jtag_tap is
    port (
        tck        : in  std_logic;
        trst       : in  std_logic;
        tms        : in  std_logic;
        state      : out std_logic_vector(3 downto 0);
        shift_dr   : out std_logic;
        shift_ir   : out std_logic;
        capture_dr : out std_logic;
        update_dr  : out std_logic;
        tlr        : out std_logic
    );
end entity;

architecture rtl of jtag_tap is
    signal s : std_logic_vector(3 downto 0) := x"F";

    function nxt(cur : std_logic_vector(3 downto 0); t : std_logic) return std_logic_vector is
        type pair_t is array (0 to 1) of std_logic_vector(3 downto 0);
        variable p : pair_t;
    begin
        case cur is
            when x"F" => p := (x"C", x"F");
            when x"C" => p := (x"C", x"7");
            when x"7" => p := (x"6", x"4");
            when x"6" => p := (x"2", x"1");
            when x"2" => p := (x"2", x"1");
            when x"1" => p := (x"3", x"5");
            when x"3" => p := (x"3", x"0");
            when x"0" => p := (x"2", x"5");
            when x"5" => p := (x"C", x"7");
            when x"4" => p := (x"E", x"F");
            when x"E" => p := (x"A", x"9");
            when x"A" => p := (x"A", x"9");
            when x"9" => p := (x"B", x"D");
            when x"B" => p := (x"B", x"8");
            when x"8" => p := (x"A", x"D");
            when x"D" => p := (x"C", x"7");
            when others => p := (x"F", x"F");
        end case;
        if t = '1' then return p(1); else return p(0); end if;
    end function;
begin
    state <= s;
    shift_dr   <= '1' when s = x"2" else '0';
    shift_ir   <= '1' when s = x"A" else '0';
    capture_dr <= '1' when s = x"6" else '0';
    update_dr  <= '1' when s = x"5" else '0';
    tlr        <= '1' when s = x"F" else '0';

    process (tck)
    begin
        if rising_edge(tck) then
            if trst = '1' then s <= x"F"; else s <= nxt(s, tms); end if;
        end if;
    end process;
end architecture;
