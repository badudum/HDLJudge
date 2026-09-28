library ieee;
use ieee.std_logic_1164.all;

entity debounce is
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        btn   : in  std_logic;
        clean : out std_logic
    );
end entity;

architecture rtl of debounce is
    signal q   : std_logic := '0';
    signal cnt : natural range 0 to 3 := 0;
begin
    clean <= q;
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                q <= '0'; cnt <= 0;
            elsif btn /= q then
                if cnt = 3 then q <= btn; cnt <= 0; else cnt <= cnt + 1; end if;
            else
                cnt <= 0;
            end if;
        end if;
    end process;
end architecture;
