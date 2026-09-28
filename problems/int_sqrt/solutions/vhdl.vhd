library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity isqrt16 is
    port (clk, rst, start : in std_logic; x : in std_logic_vector(15 downto 0);
          busy, done : out std_logic; root : out std_logic_vector(7 downto 0));
end entity;

architecture rtl of isqrt16 is
    signal xr : unsigned(15 downto 0);
    signal r  : unsigned(7 downto 0) := (others => '0');
    signal i  : natural range 0 to 7 := 0;
    signal b  : std_logic := '0';
begin
    busy <= b;
    root <= std_logic_vector(r);
    process (clk)
        variable cand : unsigned(7 downto 0);
    begin
        if rising_edge(clk) then
            done <= '0';
            if rst = '1' then
                b <= '0'; r <= (others => '0');
            elsif b = '1' then
                cand := r;
                cand(i) := '1';
                if cand * cand <= xr then r <= cand; end if;
                if i = 0 then b <= '0'; done <= '1'; else i <= i - 1; end if;
            elsif start = '1' then
                b <= '1'; xr <= unsigned(x); r <= (others => '0'); i <= 7;
            end if;
        end if;
    end process;
end architecture;
