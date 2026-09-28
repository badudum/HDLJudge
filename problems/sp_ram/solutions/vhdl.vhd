library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sp_ram64 is
    port (
        clk   : in  std_logic;
        en    : in  std_logic;
        we    : in  std_logic;
        addr  : in  std_logic_vector(5 downto 0);
        wdata : in  std_logic_vector(7 downto 0);
        rdata : out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of sp_ram64 is
    type mem_t is array (0 to 63) of std_logic_vector(7 downto 0);
    signal mem : mem_t;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if en = '1' then
                if we = '1' then mem(to_integer(unsigned(addr))) <= wdata; end if;
                rdata <= mem(to_integer(unsigned(addr)));
            end if;
        end if;
    end process;
end architecture;
