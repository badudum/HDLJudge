library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity simd_alu is
    port (
        a    : in  std_logic_vector(31 downto 0);
        b    : in  std_logic_vector(31 downto 0);
        mode : in  std_logic;
        op   : in  std_logic_vector(1 downto 0);
        y    : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of simd_alu is
    function lane(x, z : unsigned; o : std_logic_vector(1 downto 0)) return unsigned is
        constant W : natural := x'length;
        variable s : unsigned(W downto 0);
    begin
        s := ('0' & x) + ('0' & z);
        case o is
            when "00" => return s(W-1 downto 0);
            when "01" => return x - z;
            when "10" =>
                if s(W) = '1' then return (W-1 downto 0 => '1'); else return s(W-1 downto 0); end if;
            when others =>
                if x > z then return x; else return z; end if;
        end case;
    end function;
begin
    process (a, b, mode, op)
        variable r : unsigned(31 downto 0);
    begin
        if mode = '1' then
            for i in 0 to 1 loop
                r(16*i + 15 downto 16*i) := lane(unsigned(a(16*i + 15 downto 16*i)), unsigned(b(16*i + 15 downto 16*i)), op);
            end loop;
        else
            for i in 0 to 3 loop
                r(8*i + 7 downto 8*i) := lane(unsigned(a(8*i + 7 downto 8*i)), unsigned(b(8*i + 7 downto 8*i)), op);
            end loop;
        end if;
        y <= std_logic_vector(r);
    end process;
end architecture;
