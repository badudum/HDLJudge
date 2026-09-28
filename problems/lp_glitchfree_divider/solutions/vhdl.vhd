library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gf_div is
    port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        div     : in  std_logic_vector(1 downto 0);
        clk_out : out std_logic
    );
end entity;

architecture rtl of gf_div is
    signal q   : std_logic := '0';
    signal cnt : natural range 0 to 3 := 0;
    signal h   : natural range 1 to 4 := 1;
begin
    clk_out <= q;
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                q <= '0'; cnt <= 0; h <= to_integer(unsigned(div)) + 1;
            elsif cnt = h - 1 then
                cnt <= 0;
                q <= not q;
                if q = '0' then h <= to_integer(unsigned(div)) + 1; end if;
            else
                cnt <= cnt + 1;
            end if;
        end if;
    end process;
end architecture;
