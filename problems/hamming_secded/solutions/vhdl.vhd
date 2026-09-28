library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity secded_dec is
    port (
        code       : in  std_logic_vector(7 downto 0);
        data       : out std_logic_vector(3 downto 0);
        single_err : out std_logic;
        double_err : out std_logic
    );
end entity;

architecture rtl of secded_dec is
begin
    process (code)
        variable syn    : unsigned(2 downto 0);
        variable parity : std_logic;
        variable fixed  : std_logic_vector(7 downto 0);
    begin
        syn(0) := code(0) xor code(2) xor code(4) xor code(6);
        syn(1) := code(1) xor code(2) xor code(5) xor code(6);
        syn(2) := code(3) xor code(4) xor code(5) xor code(6);
        parity := xor code;
        fixed := code;
        if parity = '1' and syn /= 0 then
            fixed(to_integer(syn) - 1) := not code(to_integer(syn) - 1);
        end if;
        single_err <= parity;
        if parity = '0' and syn /= 0 then double_err <= '1'; else double_err <= '0'; end if;
        data <= fixed(6) & fixed(5) & fixed(4) & fixed(2);
    end process;
end architecture;
