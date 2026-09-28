library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity manchester_tx is
    port (clk, rst, load : in std_logic; data : in std_logic_vector(7 downto 0);
          tx, busy : out std_logic);
end entity;

architecture rtl of manchester_tx is
    signal sh : std_logic_vector(7 downto 0);
    signal k  : unsigned(3 downto 0) := (others => '0');
    signal b  : std_logic := '0';
begin
    busy <= b;
    process (clk)
        variable kn : unsigned(3 downto 0);
        variable bit_v : std_logic;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                b <= '0'; tx <= '0'; k <= (others => '0');
            elsif b = '1' then
                kn := k + 1;
                k <= kn;
                if k = 15 then
                    b <= '0'; tx <= '0';
                else
                    bit_v := sh(7 - to_integer(kn(3 downto 1)));
                    if kn(0) = '1' then tx <= bit_v; else tx <= not bit_v; end if;
                end if;
            elsif load = '1' then
                b <= '1'; sh <= data; k <= (others => '0'); tx <= not data(7);
            end if;
        end if;
    end process;
end architecture;
