library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity barrel_shifter is
    generic (
        WIDTH : positive := 8
    );
    port (
        din   : in  std_logic_vector(WIDTH-1 downto 0);
        shamt : in  std_logic_vector(integer(ceil(log2(real(WIDTH)))) - 1 downto 0);
        op    : in  std_logic_vector(1 downto 0);
        dout  : out std_logic_vector(WIDTH-1 downto 0)
    );
end entity;

architecture rtl of barrel_shifter is
begin
    process (din, shamt, op)
        variable n : natural;
    begin
        n := to_integer(unsigned(shamt));
        case op is
            when "00"   => dout <= std_logic_vector(shift_left(unsigned(din), n));
            when "01"   => dout <= std_logic_vector(shift_right(unsigned(din), n));
            when "10"   => dout <= std_logic_vector(shift_right(signed(din), n));
            when others => dout <= std_logic_vector(rotate_right(unsigned(din), n));
        end case;
    end process;
end architecture;
