library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rd_ptr_gray is
    port (
        clk          : in  std_logic;
        rst          : in  std_logic;
        rd_en        : in  std_logic;
        wr_gray_sync : in  std_logic_vector(3 downto 0);
        rd_gray      : out std_logic_vector(3 downto 0);
        rd_addr      : out std_logic_vector(2 downto 0);
        empty        : out std_logic
    );
end entity;

architecture rtl of rd_ptr_gray is
    signal b, g : unsigned(3 downto 0) := (others => '0');
    signal e    : std_logic;
begin
    e <= '1' when std_logic_vector(g) = wr_gray_sync else '0';
    empty <= e;
    rd_gray <= std_logic_vector(g);
    rd_addr <= std_logic_vector(b(2 downto 0));
    process (clk)
        variable n : unsigned(3 downto 0);
    begin
        if rising_edge(clk) then
            if rst = '1' then
                b <= (others => '0'); g <= (others => '0');
            elsif rd_en = '1' and e = '0' then
                n := b + 1;
                b <= n;
                g <= n xor shift_right(n, 1);
            end if;
        end if;
    end process;
end architecture;
