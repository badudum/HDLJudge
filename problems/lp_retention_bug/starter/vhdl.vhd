library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ret_counter is
    port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        pwr_on    : in  std_logic;
        save      : in  std_logic;
        restore   : in  std_logic;
        en        : in  std_logic;
        count_out : out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of ret_counter is
    signal count, shadow : unsigned(7 downto 0) := (others => '0');
begin
    count_out <= std_logic_vector(count) when pwr_on = '1' else x"FF";
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                count <= (others => '0'); shadow <= (others => '0');
            else
                if save = '1' then shadow <= count; end if;
                if pwr_on = '0' then count <= (others => '0');
                elsif en = '1' then count <= count + 1;
                elsif restore = '1' then count <= shadow;
                end if;
            end if;
        end if;
    end process;
end architecture;
