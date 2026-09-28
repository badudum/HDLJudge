library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tlb4 is
    port (clk, rst : in std_logic; vpn : in std_logic_vector(7 downto 0); hit : out std_logic;
          ppn : out std_logic_vector(7 downto 0); fill : in std_logic;
          fill_vpn, fill_ppn : in std_logic_vector(7 downto 0); flush : in std_logic);
end entity;

architecture rtl of tlb4 is
    type a_t is array (0 to 3) of std_logic_vector(7 downto 0);
    signal v : std_logic_vector(3 downto 0) := (others => '0');
    signal tag, pn : a_t;
    signal ptr : unsigned(1 downto 0) := "00";
begin
    process (all)
        variable h : std_logic;
        variable p : std_logic_vector(7 downto 0);
    begin
        h := '0'; p := (others => '0');
        for i in 0 to 3 loop
            if v(i) = '1' and tag(i) = vpn then h := '1'; p := pn(i); end if;
        end loop;
        hit <= h; ppn <= p;
    end process;
    process (clk)
        variable slot : natural range 0 to 3;
        variable found, use_ptr : boolean;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                v <= (others => '0'); ptr <= "00";
            elsif flush = '1' then
                v <= (others => '0');
            elsif fill = '1' then
                found := false; use_ptr := false; slot := 0;
                for i in 0 to 3 loop
                    if not found and v(i) = '1' and tag(i) = fill_vpn then slot := i; found := true; end if;
                end loop;
                for i in 0 to 3 loop
                    if not found and v(i) = '0' then slot := i; found := true; end if;
                end loop;
                if not found then slot := to_integer(ptr); use_ptr := true; end if;
                v(slot) <= '1'; tag(slot) <= fill_vpn; pn(slot) <= fill_ppn;
                if use_ptr then ptr <= ptr + 1; end if;
            end if;
        end if;
    end process;
end architecture;
