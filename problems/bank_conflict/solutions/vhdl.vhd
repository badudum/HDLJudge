library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bank_conflict is
    port (
        addr     : in  std_logic_vector(31 downto 0);
        valid    : in  std_logic_vector(3 downto 0);
        conflict : out std_logic;
        cycles   : out std_logic_vector(2 downto 0)
    );
end entity;

architecture rtl of bank_conflict is
begin
    process (addr, valid)
        type addr_t is array (0 to 3) of std_logic_vector(7 downto 0);
        type cnt_t is array (0 to 3) of natural range 0 to 4;
        variable a   : addr_t;
        variable cnt : cnt_t;
        variable dup : boolean;
        variable mx  : natural range 0 to 4;
    begin
        for i in 0 to 3 loop
            a(i) := addr(8*i + 7 downto 8*i);
            cnt(i) := 0;
        end loop;
        for i in 0 to 3 loop
            dup := false;
            for j in 0 to 3 loop
                if j < i and valid(j) = '1' and a(j) = a(i) then dup := true; end if;
            end loop;
            if valid(i) = '1' and not dup then
                cnt(to_integer(unsigned(a(i)(1 downto 0)))) := cnt(to_integer(unsigned(a(i)(1 downto 0)))) + 1;
            end if;
        end loop;
        mx := 0;
        for i in 0 to 3 loop
            if cnt(i) > mx then mx := cnt(i); end if;
        end loop;
        cycles <= std_logic_vector(to_unsigned(mx, 3));
        if mx > 1 then conflict <= '1'; else conflict <= '0'; end if;
    end process;
end architecture;
