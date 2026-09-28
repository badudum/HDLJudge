library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity prio_enc8 is
    port (
        req   : in  std_logic_vector(7 downto 0);
        idx   : out std_logic_vector(2 downto 0);
        valid : out std_logic
    );
end entity;

architecture rtl of prio_enc8 is
begin
    process (req)
    begin
        idx   <= "000";
        valid <= '0';
        for i in 0 to 7 loop
            if req(i) = '1' then
                idx   <= std_logic_vector(to_unsigned(i, 3));
                valid <= '1';
            end if;
        end loop;
    end process;
end architecture;
