library ieee;
use ieee.std_logic_1164.all;

entity misr8 is
    port (
        clk    : in  std_logic;
        rst    : in  std_logic;
        en     : in  std_logic;
        din    : in  std_logic_vector(7 downto 0);
        golden : in  std_logic_vector(7 downto 0);
        sig    : out std_logic_vector(7 downto 0);
        pass   : out std_logic
    );
end entity;

architecture rtl of misr8 is
    signal s : std_logic_vector(7 downto 0) := x"FF";
begin
    sig <= s;
    pass <= '1' when s = golden else '0';
    process (clk)
        variable fb : std_logic_vector(7 downto 0);
    begin
        if rising_edge(clk) then
            if rst = '1' then
                s <= x"FF";
            elsif en = '1' then
                if s(7) = '1' then fb := x"1D"; else fb := x"00"; end if;
                s <= (s(6 downto 0) & '0') xor fb xor din;
            end if;
        end if;
    end process;
end architecture;
