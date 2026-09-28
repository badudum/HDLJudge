library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mavg4 is
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        valid_in : in  std_logic;
        din      : in  std_logic_vector(7 downto 0);
        dout     : out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of mavg4 is
    signal x1, x2, x3 : unsigned(7 downto 0) := (others => '0');
begin
    process (clk)
        variable sum : unsigned(9 downto 0);
    begin
        if rising_edge(clk) then
            if rst = '1' then
                x1 <= (others => '0'); x2 <= (others => '0'); x3 <= (others => '0');
                dout <= (others => '0');
            elsif valid_in = '1' then
                sum := resize(unsigned(din), 10) + x1 + x2 + x3;
                x3 <= x2; x2 <= x1; x1 <= unsigned(din);
                dout <= std_logic_vector(sum(9 downto 2));
            end if;
        end if;
    end process;
end architecture;
