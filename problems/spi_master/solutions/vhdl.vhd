library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity spi_master is
    port (clk, rst, start : in std_logic; tx_data : in std_logic_vector(7 downto 0); miso : in std_logic;
          sclk, mosi, cs_n, busy, done : out std_logic; rx_data : out std_logic_vector(7 downto 0));
end entity;

architecture rtl of spi_master is
    signal c : unsigned(5 downto 0) := (others => '0');
    signal tx, rx : std_logic_vector(7 downto 0) := (others => '0');
    signal b : std_logic := '0';
begin
    busy <= b;
    process (clk)
        variable cn : unsigned(5 downto 0);
    begin
        if rising_edge(clk) then
            done <= '0';
            if rst = '1' then
                b <= '0'; c <= (others => '0'); rx_data <= (others => '0'); sclk <= '0'; mosi <= '0'; cs_n <= '1';
            elsif b = '1' then
                cn := c + 1;
                c <= cn;
                if cn(1 downto 0) = "10" then
                    sclk <= '1';
                    rx <= rx(6 downto 0) & miso;
                elsif cn(1 downto 0) = "00" then
                    sclk <= '0';
                    if cn < 32 then
                        mosi <= tx(7 - to_integer(cn(4 downto 2)));
                    else
                        cs_n <= '1'; b <= '0'; mosi <= '0'; done <= '1'; rx_data <= rx;
                    end if;
                end if;
            elsif start = '1' then
                b <= '1'; c <= (others => '0'); tx <= tx_data; cs_n <= '0'; mosi <= tx_data(7); rx <= (others => '0');
            end if;
        end if;
    end process;
end architecture;
