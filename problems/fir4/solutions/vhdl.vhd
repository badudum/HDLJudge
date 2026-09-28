library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fir4 is
    port (clk, rst, valid : in std_logic; din : in std_logic_vector(7 downto 0);
          dout : out std_logic_vector(11 downto 0));
end entity;

architecture rtl of fir4 is
    signal x1, x2, x3 : signed(11 downto 0) := (others => '0');
begin
    process (clk)
        variable a : signed(11 downto 0);
    begin
        if rising_edge(clk) then
            if rst = '1' then
                x1 <= (others => '0'); x2 <= (others => '0'); x3 <= (others => '0'); dout <= (others => '0');
            elsif valid = '1' then
                a := resize(signed(din), 12);
                dout <= std_logic_vector(a + shift_left(x1, 1) + x1 + shift_left(x2, 1) + x2 + x3);
                x1 <= a; x2 <= x1; x3 <= x2;
            end if;
        end if;
    end process;
end architecture;
