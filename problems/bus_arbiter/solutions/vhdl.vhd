library ieee;
use ieee.std_logic_1164.all;

entity bus_arb is
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        req   : in  std_logic_vector(2 downto 0);
        lock  : in  std_logic_vector(2 downto 0);
        gnt   : out std_logic_vector(2 downto 0);
        owner : out std_logic_vector(1 downto 0);
        busy  : out std_logic
    );
end entity;

architecture rtl of bus_arb is
    signal g : std_logic_vector(2 downto 0) := "000";
begin
    gnt <= g;
    busy <= g(0) or g(1) or g(2);
    owner <= "01" when g = "010" else "10" when g = "100" else "00";
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                g <= "000";
            elsif (g and req and lock) = "000" then
                if req(0) = '1' then g <= "001";
                elsif req(1) = '1' then g <= "010";
                elsif req(2) = '1' then g <= "100";
                else g <= "000";
                end if;
            end if;
        end if;
    end process;
end architecture;
