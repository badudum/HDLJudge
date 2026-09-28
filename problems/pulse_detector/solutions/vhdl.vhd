library ieee;
use ieee.std_logic_1164.all;

entity pulse_detect is
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        din   : in  std_logic;
        pulse : out std_logic
    );
end entity;

architecture rtl of pulse_detect is
    signal hist : std_logic_vector(1 downto 0) := "00";
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                hist <= "00";
                pulse <= '0';
            else
                if hist = "01" and din = '0' then pulse <= '1'; else pulse <= '0'; end if;
                hist <= hist(0) & din;
            end if;
        end if;
    end process;
end architecture;
