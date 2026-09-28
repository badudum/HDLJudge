library ieee;
use ieee.std_logic_1164.all;

entity sync_edge is
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        din   : in  std_logic;
        level : out std_logic;
        rise  : out std_logic;
        fall  : out std_logic
    );
end entity;

architecture rtl of sync_edge is
    signal s1, s2, s3 : std_logic := '0';
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                s1 <= '0'; s2 <= '0'; s3 <= '0';
            else
                s1 <= din; s2 <= s1; s3 <= s2;
            end if;
        end if;
    end process;

    level <= s2;
    rise  <= s2 and not s3;
    fall  <= s3 and not s2;
end architecture;
