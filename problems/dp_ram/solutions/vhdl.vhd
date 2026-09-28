library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dp_ram32 is
    port (
        clk    : in  std_logic;
        we_a   : in  std_logic;
        addr_a : in  std_logic_vector(4 downto 0);
        din_a  : in  std_logic_vector(7 downto 0);
        dout_a : out std_logic_vector(7 downto 0);
        we_b   : in  std_logic;
        addr_b : in  std_logic_vector(4 downto 0);
        din_b  : in  std_logic_vector(7 downto 0);
        dout_b : out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of dp_ram32 is
    type mem_t is array (0 to 31) of std_logic_vector(7 downto 0);
    signal mem : mem_t;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            dout_a <= mem(to_integer(unsigned(addr_a)));
            dout_b <= mem(to_integer(unsigned(addr_b)));
            if we_b = '1' then mem(to_integer(unsigned(addr_b))) <= din_b; end if;
            if we_a = '1' then mem(to_integer(unsigned(addr_a))) <= din_a; end if;
        end if;
    end process;
end architecture;
