library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top3 is
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        valid : in  std_logic;
        din   : in  std_logic_vector(7 downto 0);
        t0    : out std_logic_vector(7 downto 0);
        t1    : out std_logic_vector(7 downto 0);
        t2    : out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of top3 is
    signal a, b, c : unsigned(7 downto 0) := (others => '0');
begin
    t0 <= std_logic_vector(a); t1 <= std_logic_vector(b); t2 <= std_logic_vector(c);
    process (clk)
        variable d : unsigned(7 downto 0);
    begin
        if rising_edge(clk) then
            d := unsigned(din);
            if rst = '1' then
                a <= (others => '0'); b <= (others => '0'); c <= (others => '0');
            elsif valid = '1' then
                if d > a then
                    a <= d; b <= a; c <= b;
                elsif d > b then
                    b <= d; c <= b;
                elsif d > c then
                    c <= d;
                end if;
            end if;
        end if;
    end process;
end architecture;
