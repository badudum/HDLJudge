library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rr_arbiter4 is
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        req   : in  std_logic_vector(3 downto 0);
        grant : out std_logic_vector(3 downto 0)
    );
end entity;

architecture rtl of rr_arbiter4 is
    signal ptr : unsigned(1 downto 0) := "00";
begin
    process (clk)
        variable j : unsigned(1 downto 0);
        variable g : std_logic_vector(3 downto 0);
    begin
        if rising_edge(clk) then
            if rst = '1' then
                ptr   <= "00";
                grant <= "0000";
            else
                for k in 0 to 3 loop
                    j := ptr + k;
                    if req(to_integer(j)) = '1' then
                        g := (others => '0');
                        g(to_integer(j)) := '1';
                        grant <= g;
                        ptr <= j;
                        exit;
                    end if;
                end loop;
            end if;
        end if;
    end process;
end architecture;
