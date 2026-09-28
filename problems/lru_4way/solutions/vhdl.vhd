library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lru4 is
    port (
        clk    : in  std_logic;
        rst    : in  std_logic;
        touch  : in  std_logic;
        way    : in  std_logic_vector(1 downto 0);
        victim : out std_logic_vector(1 downto 0)
    );
end entity;

architecture rtl of lru4 is
    type age_t is array (0 to 3) of natural range 0 to 3;
    signal age : age_t := (3, 2, 1, 0);
begin
    process (clk)
        variable w : natural range 0 to 3;
    begin
        if rising_edge(clk) then
            w := to_integer(unsigned(way));
            if rst = '1' then
                age <= (3, 2, 1, 0);
            elsif touch = '1' then
                for i in 0 to 3 loop
                    if i = w then
                        age(i) <= 0;
                    elsif age(i) < age(w) then
                        age(i) <= age(i) + 1;
                    end if;
                end loop;
            end if;
        end if;
    end process;

    process (age)
    begin
        victim <= "00";
        for i in 0 to 3 loop
            if age(i) = 3 then victim <= std_logic_vector(to_unsigned(i, 2)); end if;
        end loop;
    end process;
end architecture;
