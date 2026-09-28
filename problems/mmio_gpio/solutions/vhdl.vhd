library ieee;
use ieee.std_logic_1164.all;

entity mmio_gpio is
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        we       : in  std_logic;
        addr     : in  std_logic_vector(1 downto 0);
        wdata    : in  std_logic_vector(7 downto 0);
        rdata    : out std_logic_vector(7 downto 0);
        gpio_in  : in  std_logic_vector(7 downto 0);
        gpio_out : out std_logic_vector(7 downto 0);
        gpio_oe  : out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of mmio_gpio is
    signal o, d, s1, s2, s3, rise : std_logic_vector(7 downto 0) := (others => '0');
begin
    gpio_out <= o;
    gpio_oe <= d;
    with addr select rdata <= o when "00", d when "01", s2 when "10", rise when others;
    process (clk)
        variable clr : std_logic_vector(7 downto 0);
    begin
        if rising_edge(clk) then
            if rst = '1' then
                o <= (others => '0'); d <= (others => '0'); s1 <= (others => '0');
                s2 <= (others => '0'); s3 <= (others => '0'); rise <= (others => '0');
            else
                s1 <= gpio_in; s2 <= s1; s3 <= s2;
                clr := (others => '0');
                if we = '1' and addr = "11" then clr := wdata; end if;
                rise <= (rise and not clr) or (s2 and not s3);
                if we = '1' and addr = "00" then o <= wdata; end if;
                if we = '1' and addr = "01" then d <= wdata; end if;
            end if;
        end if;
    end process;
end architecture;
