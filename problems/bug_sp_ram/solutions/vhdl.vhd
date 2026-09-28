library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sp_ram16 is
    port (
        clk   : in  std_logic;
        en    : in  std_logic;
        we    : in  std_logic;
        addr  : in  std_logic_vector(3 downto 0);
        wdata : in  std_logic_vector(7 downto 0);
        rdata : out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of sp_ram16 is
    type mem_t is array (0 to 15) of std_logic_vector(7 downto 0);
    signal mem : mem_t;
begin
    process (clk)
        variable a : natural range 0 to 15;
    begin
        if rising_edge(clk) then
            a := to_integer(unsigned(addr));
            if en = '1' then
                if we = '1' then
                    mem(a) <= wdata;
                    rdata <= wdata;
                else
                    rdata <= mem(a);
                end if;
            end if;
        end if;
    end process;
end architecture;
