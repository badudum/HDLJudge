library ieee;
use ieee.std_logic_1164.all;

entity scan_reg is
    port (
        clk : in  std_logic;
        rst : in  std_logic;
        d   : in  std_logic_vector(7 downto 0);
        se  : in  std_logic;
        si  : in  std_logic;
        q   : out std_logic_vector(7 downto 0);
        so  : out std_logic
    );
end entity;

architecture rtl of scan_reg is
    signal r : std_logic_vector(7 downto 0) := (others => '0');
begin
    q <= r;
    so <= r(7);
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then r <= (others => '0');
            elsif se = '1' then r <= r(6 downto 0) & si;
            else r <= d;
            end if;
        end if;
    end process;
end architecture;
