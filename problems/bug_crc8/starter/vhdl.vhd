library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity crc8 is
    port (clk, rst, init, valid : in std_logic; data : in std_logic_vector(7 downto 0);
          crc : out std_logic_vector(7 downto 0));
end entity;

architecture rtl of crc8 is
    signal r : std_logic_vector(7 downto 0) := (others => '0');
begin
    crc <= r;
    process (clk)
        variable c : std_logic_vector(7 downto 0);
    begin
        if rising_edge(clk) then
            if rst = '1' then
                r <= (others => '0');
            elsif valid = '1' then
                c := r;
                for i in 0 to 7 loop
                    if (c(7) xor data(i)) = '1' then c := (c(6 downto 0) & '0') xor x"07";
                    else c := c(6 downto 0) & '0';
                    end if;
                end loop;
                r <= c;
            elsif init = '1' then
                r <= (others => '0');
            end if;
        end if;
    end process;
end architecture;
