library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity last_n_ones is
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        din   : in  std_logic;
        count : out std_logic_vector(3 downto 0);
        alarm : out std_logic
    );
end entity;

architecture rtl of last_n_ones is
    signal window : std_logic_vector(11 downto 0) := (others => '0');
    signal c      : unsigned(3 downto 0) := (others => '0');
begin
    count <= std_logic_vector(c);
    process (clk)
        variable n : unsigned(3 downto 0);
    begin
        if rising_edge(clk) then
            if rst = '1' then
                window <= (others => '0');
                c <= (others => '0');
                alarm <= '0';
            else
                n := c;
                if din = '1' then n := n + 1; end if;
                if window(11) = '1' then n := n - 1; end if;
                window <= window(10 downto 0) & din;
                c <= n;
                if n >= 8 then alarm <= '1'; else alarm <= '0'; end if;
            end if;
        end if;
    end process;
end architecture;
