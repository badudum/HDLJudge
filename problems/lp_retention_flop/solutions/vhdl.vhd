library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ret_reg is
    port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        pwr_on  : in  std_logic;
        save    : in  std_logic;
        restore : in  std_logic;
        en      : in  std_logic;
        d       : in  std_logic_vector(7 downto 0);
        q_out   : out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of ret_reg is
    signal q, shadow : std_logic_vector(7 downto 0) := (others => '0');
begin
    q_out <= q when pwr_on = '1' else (others => '0');
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                q <= (others => '0'); shadow <= (others => '0');
            else
                if save = '1' and pwr_on = '1' then shadow <= q; end if;
                if pwr_on = '0' then q <= (others => '0');
                elsif restore = '1' then q <= shadow;
                elsif en = '1' then q <= d;
                end if;
            end if;
        end if;
    end process;
end architecture;
