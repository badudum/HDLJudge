library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity iso_alu is
    port (
        clk    : in  std_logic;
        rst    : in  std_logic;
        en     : in  std_logic;
        op     : in  std_logic;
        a      : in  std_logic_vector(7 downto 0);
        b      : in  std_logic_vector(7 downto 0);
        y      : out std_logic_vector(15 downto 0);
        add_in : out std_logic_vector(15 downto 0);
        mul_in : out std_logic_vector(15 downto 0)
    );
end entity;

architecture rtl of iso_alu is
    signal add_a, add_b, mul_a, mul_b : unsigned(7 downto 0) := (others => '0');
    signal op_q : std_logic := '0';
begin
    add_in <= std_logic_vector(add_a & add_b);
    mul_in <= std_logic_vector(mul_a & mul_b);
    y <= std_logic_vector(mul_a * mul_b) when op_q = '1' else std_logic_vector(resize(add_a, 16) + resize(add_b, 16));
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                add_a <= (others => '0'); add_b <= (others => '0'); mul_a <= (others => '0'); mul_b <= (others => '0'); op_q <= '0';
            elsif en = '1' then
                op_q <= op;
                if op = '1' then mul_a <= unsigned(a); mul_b <= unsigned(b);
                else add_a <= unsigned(a); add_b <= unsigned(b);
                end if;
            end if;
        end if;
    end process;
end architecture;
