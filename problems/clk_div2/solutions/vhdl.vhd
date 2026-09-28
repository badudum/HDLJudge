library ieee;
use ieee.std_logic_1164.all;

entity clk_div2 is
    port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        clk_out : out std_logic
    );
end entity;

architecture rtl of clk_div2 is
    signal q : std_logic := '0';
begin
    clk_out <= q;
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then q <= '0'; else q <= not q; end if;
        end if;
    end process;
end architecture;
