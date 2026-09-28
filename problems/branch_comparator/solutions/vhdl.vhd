library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity branch_cmp is
    port (
        a      : in  std_logic_vector(31 downto 0);
        b      : in  std_logic_vector(31 downto 0);
        funct3 : in  std_logic_vector(2 downto 0);
        taken  : out std_logic
    );
end entity;

architecture rtl of branch_cmp is
begin
    process (a, b, funct3)
        variable eq, lt, ltu, t : boolean;
    begin
        eq  := a = b;
        lt  := signed(a) < signed(b);
        ltu := unsigned(a) < unsigned(b);
        case funct3 is
            when "000"  => t := eq;
            when "001"  => t := not eq;
            when "100"  => t := lt;
            when "101"  => t := not lt;
            when "110"  => t := ltu;
            when "111"  => t := not ltu;
            when others => t := false;
        end case;
        if t then taken <= '1'; else taken <= '0'; end if;
    end process;
end architecture;
