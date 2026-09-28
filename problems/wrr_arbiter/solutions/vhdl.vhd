library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity wrr_arb is
    port (clk, rst : in std_logic; req : in std_logic_vector(2 downto 0); gnt : out std_logic_vector(2 downto 0));
end entity;

architecture rtl of wrr_arb is
    type w_t is array (0 to 2) of natural;
    constant W : w_t := (3, 2, 1);
    signal cur : natural range 0 to 2 := 2;
    signal cnt : natural range 0 to 3 := 1;
begin
    process (clk)
        variable i : natural range 0 to 2;
        variable found : boolean;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                cur <= 2; cnt <= 1; gnt <= "000";
            elsif req(cur) = '1' and cnt < W(cur) then
                cnt <= cnt + 1;
                gnt <= (others => '0'); gnt(cur) <= '1';
            else
                found := false;
                gnt <= "000";
                for k in 1 to 3 loop
                    i := (cur + k) mod 3;
                    if not found and req(i) = '1' then
                        found := true;
                        cur <= i; cnt <= 1;
                        gnt <= (others => '0'); gnt(i) <= '1';
                    end if;
                end loop;
            end if;
        end if;
    end process;
end architecture;
